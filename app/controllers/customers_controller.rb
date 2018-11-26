class CustomersController < ApplicationController
    before_action :authenticate_customer!
    before_action :own_reservations, only: :reservation_meals
  
    def bookings
        @bookings = current_customer.reservations
    end
    
    def reservation_meals
        @meals = @reservation.meals
    end
    
    private
    
    def own_reservations
        @reservation = Reservation.find_by(id: params[:id])
        redirect_to root_path if !(current_customer.reservations.include? @reservation)
    end
end
