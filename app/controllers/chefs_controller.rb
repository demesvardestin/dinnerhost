class ChefsController < ApplicationController
  before_action :authenticate_chef!, except: :show
  
  def dashboard
  end
  
  def show
    @chef = Chef.find_by(id: params[:id])
  end
  
end
