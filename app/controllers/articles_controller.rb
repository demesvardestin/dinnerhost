class ArticlesController < ApplicationController
  before_action :set_article, only: [:edit, :update, :show]
  before_action :authenticate_admin!, only: [:new, :create, :edit, :update]
  before_action :own_post, only: [:edit, :update]
  
  def new
    @article = Article.new
  end
  
  def create
    @article = Article.new(article_params)
    @article.admin_id = current_admin.id
    @article.author = current_admin.name
    if params[:article][:draft] == 'true'
      @article.draft = true
    else
      @article.draft = false
    end
    respond_to do |format|
      if @article.save
        format.html { redirect_to admin_posts_path, notice: "Your post has been created!"}
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
    if params[:article][:draft] == 'true'
      params[:article][:draft] = true
    else
      params[:article][:draft] = false
    end
    @article.update(article_params)
    redirect_to admin_posts_path
  end

  def show
  end

  def index
  end
  
  def filter_by_category
    category = params[:category]
    @articles = Article.published.where(category: category.downcase)
    render :layout => false
  end
  
  private
  
  def own_post
    if current_admin && !current_admin.owns(Article.find(params[:id]))
      redirect_to blog_path, notice: "You are not authorized to edit this article"
    end
  end
  
  def set_article
    @article = Article.find_by(id: params[:id])
  end
  
  def article_params
    params.require(:article).permit(:title, :content, :tags, :author, :banner_image, :admin_id, :category, :draft)
  end
  
end
