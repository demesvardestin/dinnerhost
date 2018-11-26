class MealsController < ApplicationController
  before_action :authenticate_chef!, except: [:show, :reserve, :booking_confirmation]
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
        format.html { redirect_to @meal, notice: "Event updated!" }
      else
        render :edit
      end
    end
  end

  def show
    @cook = Chef.find_by(id: @meal.chef_id)
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
      @meal = Meal.find_by(id: params[:data][:meal_id])
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
    params.require(:meal).permit(:name, :description, :street_address, :town, :state,
                                :zipcode, :image, :dish_order, :serving_temperature,
                                :allergens, :tags)
  end
  
  def meal_report_params
    params.require(:meal_report).permit(:report_type, :details, :meal_id, :customer_id)
  end
  
  def reservation_params
    params.require(:reservation).permit(:start_date, :end_date, :adult_count, :children_count)
  end
end
