class MealsController < ApplicationController
  before_action :authenticate_chef!, only: [:create, :update, :edit, :destroy]
  before_action :authenticate_customer!, only: [:reserve, :booking_confirmation]
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
    @meal.street_address = current_chef.street_address
    @meal.town = current_chef.town
    @meal.state = current_chef.state
    @meal.zipcode = current_chef.zipcode
    respond_to do |format|
      if @meal.save
        format.html { redirect_to "/dish/#{@meal.id}/#{@meal.slug}", notice: "Event updated!" }
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
  
  def set_meal
    @meal = Meal.not_deleted.find_by(id: params[:id])
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
            :allergens, :tags, :meal_type, :prep_fee, :course, :flavor)
  end
  
  def meal_report_params
    params.require(:meal_report).permit(:report_type, :details, :meal_id, :customer_id)
  end
  
  def reservation_params
    params.require(:reservation).permit(:start_date, :end_date, :adult_count, :children_count)
  end
end
