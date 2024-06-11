class ArticleForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  # 型やデフォルト値を持たせたいなら attribute をつかう
  # そうでないなら attr_accessor をつかう
  # cf https://zenn.dev/ndjndj/articles/154cc0701bc658

  # titleとcontentはDBに実際に登録されているカラムであり型も持たせたいため attribute をつかう
  attribute :title, :string
  attribute :content, :string

  attr_accessor :user, :article
  
  # バリデーションをモデルファイルから移行してきた
  validates :title, presence: true, length: { maximum: 10}
  validates :content, presence: true
  
  # ArticleFormインスタンス生成と同時に呼び出される
  def initialize(user, article, attributes = {})
    @user = user        # @article_form.user = current_user
    @article = article  # @article_form.article = Article.new

    super(attributes)   # 後述
  end

  def save
    return false unless valid? # バリデーション実行
    article.user = user # ユーザと紐付け
    ActiveRecord::Base.transaction do
      article.update!(attributes) # モデルを使って保存 {"title"=>"日報", "content"=>"aaaa"}
    end
    true
  end
end


# 別のやり方
# class ArticleForm
#   include ActiveModel::Model
#   include ActiveModel::Attributes

#   attr_accessor :user, :article

#   attributeを使わず、代わりにgetter, setterで対応する
  
#   validates :title, presence: true, length: { maximum: 10}
#   validates :content, presence: true
  
#   def initialize(user, article, attributes = {})
#     @user = user
#     @article = article
#     super(attributes)
#   end
  
#   # getter
#   def title
#     puts "f.text_field :title / unless valid?でのtitleカラムの値へのアクセス / article.update!でのtitleカラムの値へのアクセスで呼び出される"
#     @title
#   end

#   def content
#     puts "f.text_area :content / unless valid?でのcontentカラムの値へのアクセス / article.update!でのcontentカラムの値へのアクセスで呼び出される"
#     @content
#   end

#   # setter
#   def title=(title)
#     puts "ArticleForm.new(current_user, Article.new, article_params)でtiteカラムの値を設定するときに呼び出される"
#     @title = title
#   end

#   def content=(content)
#     puts "ArticleForm.new(current_user, Article.new, article_params)でcontentカラムの値を設定するときに呼び出される"
#     @content = content
#   end

#   def save
#     return false unless valid?
#     article.user = user
#     ActiveRecord::Base.transaction do
#       article.update!(title: title, content: content)
#     end
#     true
#   end
# end


# super(attributes)は以下の内容
# @attributes = self.class._default_attributes.deep_dup
# assign_attributes(attributes)
# cf https://qiita.com/kazutosato/items/91c5c989f98981d06cd4

# newアクションの場合
# (byebug) @attributes
# #<ActiveModel::AttributeSet:0x0000000107d3e390 @attributes={}>
# (byebug) assign_attributes(attributes)
# nil

# createアクションの場合
# (byebug) @attributes
# #<ActiveModel::AttributeSet:0x0000000107069480 @attributes={}>
# (byebug) assign_attributes(attributes)
# {"title"=>"日報", "content"=>"aaaa"}
