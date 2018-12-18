class MealsController < ApplicationController
  before_action :authenticate_chef!, only: [:create, :create_ingredient, :ingredients_list, :update, :edit, :destroy]
  before_action :own_meal, only: [:edit, :update, :destroy, :ingredients_list]
  before_action :authenticate_customer!, only: [:reserve, :booking_confirmation]
  before_action :set_meal, only: [:update, :show, :edit, :destroy]
  before_action :set_meal_attributes, only: :new
  
  def create
    @meal = Meal.new(meal_params)
    @meal.chef = current_chef
    respond_to do |format|
      if @meal.save
        format.html { redirect_to add_ingredients_path(:id => @meal.id) }
      else
        render :new
      end
    end
  end
  
  def create_ingredient
    @ingredient = Ingredient.new(ingredient_params)
    @meal = Meal.find_by(id: params[:ingredient][:meal_id])
    own_meal @meal.id
    
    @ingredient.meal = @meal
    @ingredient.chef = current_chef
    respond_to do |format|
      if @ingredient.save
        @ingredients = @meal.ingredients
        format.js { render "ingredient_added", :layout => false }
      else
        format.js { render "common/error", :layout => false }
      end
    end
  end
  
  def remove_ingredient
    @ingredient = Ingredient.find_by(id: params[:id])
    @meal = Meal.find_by(:id => params[:meal_id])
    own_meal @meal.id
    
    return warn if not_proper_user @ingredient
    @ingredient.destroy
    
    @ingredients = @meal.ingredients
    render "ingredient_removed", :layout => false
  end
  
  def ingredients_list
    @meal = Meal.find_by(id: params[:id])
    @ingredient = Ingredient.new
  end
  
  def update
    @meal.update(meal_params)
    @meal.street_address = current_chef.street_address
    @meal.town = current_chef.town
    @meal.state = current_chef.state
    @meal.zipcode = current_chef.zipcode
    respond_to do |format|
      if @meal.save
        @notice = "Listing updated!"
        format.js { render "common/show_notice", :layout => false }
      else
        render :edit
      end
    end
  end

  def show
    @cook = Chef.find_by(id: @meal.chef_id)
    @reviews = @meal.meal_ratings.reverse
  end
  
  def search_meal_reviews
    @meal = Meal.not_deleted.find(params[:meal_id])
    @reviews = @meal.meal_ratings.search(params[:search])
    render :layout => false
  end
  
  def browse_reviews
    page = params[:page]
    @meal = Meal.not_deleted.find(params[:meal_id])
    @all_reviews = @meal.meal_ratings.reverse
    if page.present?
      @page = page.to_i
      if @page > 1
        idx = @page - 2
        @page_start = (@page * 2) + 1 + (3*idx)
        @page_end = @page_start + 4
        @reviews = @meal.meal_ratings.reverse[@page_start..@page_end]
      elsif page.to_i == 1
        @reviews = @meal.meal_ratings.reverse[0..4]
      end
    else
      @reviews = @meal.meal_ratings.reverse[0..4]
    end
    render :layout => false
  end
  
  def search_by_tag
    @meals = Meal.search(params[:tag])
  end
  
  def search_by_category
    @meals = Meal.not_deleted.filter_type(params[:category])
  end
  
  def filtered_search
    data = params["data"]
    @meal_type = data["meal_type"]
    @request_location = data["request_location"]
    @filter_data = JSON.parse(data["filters"]) if data["filters"]
    
    filtered_by_type_and_location = Meal.not_deleted.filter_type(@meal_type).near(@request_location, 20)
    @meals = Meal.process_filters(@filter_data, filtered_by_type_and_location)
    render :layout => false
  end
  
  def location_based_listings
    @meals = Meal.not_deleted.near(params[:location], 15)
  end
  
  def reserve
    @reservation = Reservation.new(reservation_params)
    respond_to do |format|
      if @reservation.save
        format.html { redirect_to "/booking/confirmation/#{@reservation.id}" }
      end
    end
  end
  
  def book
    begin
      @meal = Meal.not_deleted.find_by(id: params[:data][:meal_id])
      @reservation = Reservation.book_chef(@meal, params[:data][:card_token][:id], current_customer)
    rescue
      render 'unable_to_book', :layout => false
      return
    end
  end
  
  def booking_confirmation
    @reservation = Reservation.find_by(id: params[:id])
  end
  
  def report_meal
    @report = MealReport.new(meal_report_params)
    respond_to do |params|
      if @report.save
        format.js { render 'report_sent', :layout => false }
      end
    end
  end

  def edit
  end
  
  def destroy
    @meal.update(deleted: true)
    redirect_to "/chef/edit/listings", notice: "Listing successfully removed!"
  end
  
  private
  
  def set_meal(id=nil)
    @meal = Meal.not_deleted.find(id || params[:id])
  end
  
  def own_meal(id=nil)
    set_meal id
    @notice = "Unauthorized access!"
    
    if @meal.chef != current_chef
      if request.xhr?
        render "common/unauthorized", :layout => false
      else
        redirect_to :back, notice: @notice
      end
    end
  end
  
  def set_meal_attributes
    @meal = Meal.new
    @meal.street_address = current_chef.street_address
    @meal.town = current_chef.town
    @meal.state = current_chef.state
    @meal.zipcode = current_chef.zipcode
  end
  
  def meal_params
    params
    .require(:meal)
    .permit(:name, :description, :street_address, :town, :state,
            :zipcode, :image, :dish_order, :serving_temperature,
            :allergens, :tags, :meal_type, :prep_fee, :course, :flavor,
            :notable_ingredients)
  end
  
  def ingredient_params
    params.require(:ingredient).permit(:name, :quantity, :additional_details)
  end
  
  def meal_report_params
    params.require(:meal_report).permit(:report_type, :details, :meal_id, :customer_id)
  end
  
  def reservation_params
    params.require(:reservation).permit(:start_date, :end_date, :adult_count, :children_count)
  end
  
  def current_user
    current_chef || current_customer
  end
  
  def not_proper_user(obj)
    obj.user != current_user
  end
  
  def warn
    @notice = "Unauthorized Access!"
    render "common/unauthorized", :layout => false
  end
end
