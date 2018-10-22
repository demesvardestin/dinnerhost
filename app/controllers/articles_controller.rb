class ArticlesController < ApplicationController
  before_action :own_article, only: [:edit, :update]
  before_action :set_article, only: [:edit, :update, :show]
  before_action :authenticate_admin!, only: [:new, :create, :edit, :update]
  before_action :own_post, only: [:edit, :update]
  
  def new
    @article = Article.new
  end
  
  def create
    @article = Article.new(article_params)
    respond_to do |format|
      if @article.save
        format.html { redirect_to blog_path, notice: "Your post has been created!"}
      end
    end
  end

  def edit
    
  end

  def update
    if @article.nil?
      render 'unable_to_find_article', :layout => false
      return
    end
    @article.update(article_params)
    render :layout => false
  end

  def show
  end

  def index
  end
  
  def filter_by_category
    category = params[:category]
    @articles = Article.where(category: category.capitalize)
    render :layout => false
  end
  
  private
  
  def set_article
    @article = Article.find_by(id: params[:id])
  end
  
  def article_params
    params.require(:article).permit(:title, :content, :tags, :author, :banner_image, :admin_id, :category)
  end
  
end
