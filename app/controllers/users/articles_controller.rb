class Users::ArticlesController < ApplicationController
  before_action :set_article, only:[:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  def index
    @articles = current_user.articles
  end

  def new
    @article = current_user.articles.build
  end

  def create
    @article = current_user.articles.build(article_params)
    if @article.save
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
      params.require(:article).permit(:title, :content, :img)
    end

    def set_article
      @article = current_user.articles.find(params[:id])
    end
end
