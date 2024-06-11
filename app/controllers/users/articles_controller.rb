class Users::ArticlesController < ApplicationController
  before_action :set_article, only:[:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  def index
    @articles = current_user.articles
  end

  def new
    @article_form = ArticleForm.new(current_user, Article.new)
  end

  def create
    @article_form = ArticleForm.new(current_user, Article.new, article_params)
    # (byebug) @article_form
    #<Articles::Form:0x00000001067a1af0 
    # @user=#<User id: 1, email: "sample@email.com", created_at: "2024-05-09 01:24:16.617581000 +0900", updated_at: "2024-05-09 01:24:16.617581000 +0900", name: "サンプルユーザ">, 
    # @article=#<Article id: nil, title: nil, content: nil, user_id: nil, created_at: nil, updated_at: nil>, 
    # @attributes=#<ActiveModel::AttributeSet:0x00000001067a1938 
    #   @attributes={"title"=>#<ActiveModel::Attribute::FromUser:0x00000001067a1320 @name="title", @value_before_type_cast="日報", @type=#<ActiveModel::Type::String:0x00000001067b0b90 @true="t", @false="f", @precision=nil, @scale=nil, @limit=nil>, @original_attribute=#<ActiveModel::Attribute::WithCastValue:0x00000001067a19b0 @name="title", @value_before_type_cast=nil, @type=#<ActiveModel::Type::String:0x00000001067b0b90 @true="t", @false="f", @precision=nil, @scale=nil, @limit=nil>, @original_attribute=nil>>,
    #                "content"=>#<ActiveModel::Attribute::FromUser:0x00000001067a1280 @name="content", @value_before_type_cast="がんまりました。", @type=#<ActiveModel::Type::String:0x00000001067aae48 @true="t", @false="f", @precision=nil, @scale=nil, @limit=nil>, @original_attribute=#<ActiveModel::Attribute::WithCastValue:0x00000001067a1988 @name="content", @value_before_type_cast=nil, @type=#<ActiveModel::Type::String:0x00000001067aae48 @true="t", @false="f", @precision=nil, @scale=nil, @limit=nil>, @original_attribute=nil>>

    # (byebug) @article_form.user
    # #<User id: 1, email: "sample@email.com", created_at: "2024-05-09 01:24:16.617581000 +0900", updated_at: "2024-05-09 01:24:16.617581000 +0900", name: "サンプルユーザ">

    # (byebug) @article_form.article 
    # #<Article id: nil, title: nil, content: nil, user_id: nil, created_at: nil, updated_at: nil>
    
    # (byebug) @article_form.attributes
    # {"title"=>"日報", "content"=>"あああ"}
    # @article_form.title → "日報"
    # @article_form.content → "あああ"

    if @article_form.save
      flash[:success]="新規投稿に成功しました"
      redirect_to users_articles_url
    else
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @article.update(article_params)
      flash[:success]="投稿を編集しました"
      redirect_to users_articles_url 
    else
      render :edit
    end
  end

  def destroy
    @article.destroy
    flash[:success] = "投稿を削除しました"
    redirect_to users_articles_path 
  end

  private
  
    def article_params
      params.require(:article_form).permit(:title, :content)
    end

    def set_article
      @article = current_user.articles.find(params[:id])
    end
end
