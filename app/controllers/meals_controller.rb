class MealsController < ApplicationController
  before_action :authenticate_chef!, except: :show
  before_action :set_meal, only: [:create, :update, :show, :edit, :destroy]
  before_action :set_meal_attributes, only: :new
  
  def create
    @meal = Meal.new(meal_params)
    @meal.chef = current_chef
    respond_to do |format|
      if @meal.save
        format.html { redirect_to @meal, notice: 'Meal created'}
      else
        render :new
      end
    end
  end
  
  def update
    @meal.update(meal_params)
    respond_to do |format|
      if @meal.save
        format.html { redirect_to @meal, notice: "Event updated!" }
      else
        render :edit
      end
    end
  end

  def show
  end

  def edit
  end
  
  def destroy
    @meal.delete
    redirect_to chef_dashboard_path
  end
  
  private
  
  def set_meal
    @meal = Meal.find_by(id: params[:id])
  end
  
  def set_meal_attributes
    @meal = Meal.new
    @meal.street_address = current_chef.street_address
    @meal.town = current_chef.town
    @meal.state = current_chef.state
    @meal.zipcode = current_chef.zipcode
  end
  
  def meal_params
    params.require(:meal).permit(:name, :description, :street_address, :town, :state, :zipcode)
  end
end
