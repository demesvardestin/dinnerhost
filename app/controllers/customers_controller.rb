class CustomersController < ApplicationController
  before_action :authenticate_customer!
  
  def make_reservation
    @meal = Meal.find_by(id: params[:id])
  end
  
  def reserve
    # begin
      @meal = Meal.find_by(id: params[:data][:meal_id])
      @reservation = Reservation.book_chef(@meal, params[:data][:card_token][:id], current_customer)
    # rescue
    #   render 'unable_to_book', :layout => false
    #   return
    # end
    redirect_to booking_confirmation_path(:confirmation_id => @reservation.id)
  end
  
  def booking_confirmation
    @reservation = Reservation.find_by(id: params[:confirmation_id])
    @meal = Meal.find_by(id: @reservation.meal_id)
  end
  
end
