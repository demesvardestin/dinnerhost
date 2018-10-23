class AdminsController < ApplicationController
  before_action :authenticate_admin!, except: [:show]
  before_action :own_profile, only: [:edit, :update]
  before_action :set_admin
  
  def show
    @articles = Article.published.where(admin_id: @admin.id)
  end

  def edit
    
  end

  def update
    @admin.update(admin_params)
    render :layout => false
  end

  def create
  end
  
  def dashboard
    @published = Article.published.where(admin_id: current_admin.id)
    @drafts = Article.drafted.where(admin_id: current_admin.id)
  end
  
  def profile_picture
    image = params[:data][:url]
    current_admin.update(profile_image: image)
    render 'profile_image_added', :layout => false
  end
  
  private
  
  def own_profile
    if params[:id]
      @admin = Admin.find(params[:id])
      if @admin.id != current_admin.id
        redirect_to blog_path, notice: "You're not allowed to access this page!"
      end
    end
  end
  
  def set_admin
    @admin = current_admin || Admin.find(params[:id])
  end
  
  def admin_params
    params.require(:admin).permit(:first_name, :last_name, :email, :profile_image, :bio)
  end
end
