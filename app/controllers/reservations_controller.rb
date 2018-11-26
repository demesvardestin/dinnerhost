class ReservationsController < ApplicationController
  before_action :set_reservation
  before_action :authorized_to_view, except: [:reserve, :book, :booking_estimate]
  before_action :load_booking_estimate, only: [:booking_estimate, :reserve]
  
  def show
  end
  
  def book
    @cook = Chef.find_by(id: params[:id]) || Chef.find_by(username: params[:username])
  end
  
  def booking_estimate
    render :layout => false
  end
  
  def reserve
    @reservation = Reservation.new(reservation_params)
    @reservation.customer = current_customer
    @reservation.chef = @chef
    @reservation.fee = @booking_rate.to_s
    respond_to do |format|
      if @reservation.save
        format.html { redirect_to "/booking/confirmation/#{@reservation.id}" }
      end
    end
  end
  
  def complete_reservation
    @reservation.update(reservation_params)
    @reservation.active = true
    respond_to do |format|
      if @reservation.save
        @conversation = create_initial_message(@reservation.chef, @reservation.additional_message)
        format.html { redirect_to "/chat/#{@conversation.id}" }
      end
    end
  end
  
  def booking_confirmation
    @cook = @reservation.chef
  end
  
  def create_initial_message(cook, message_content)
    @conversation = Conversation.create(chef_id: cook.id, customer_id: current_customer.id)
    @message = Message.create(
                content: message_content,
                sender_type: "customer",
                customer_id: current_customer.id,
                chef_id: cook.id,
                conversation_id: @conversation.id
              )
    # MessageUpdate.alert_receiver @message, @message.sender, @message.receiver
    return @conversation
  end
  
  def booking_complete
  end
  
  def reservation_accepted
    @cook = current_chef
    @reservation = Reservation.find(params[:id])
    redirect_to root_path if @cook != @reservation.chef
  end
  
  private
  
  def set_reservation
    @reservation = Reservation.find_by(id: params[:id])
  end
  
  def user
    current_customer || current_chef
  end
  
  def authorized_to_view
    @reservation = set_reservation
    if !(@reservation.user == user)
      redirect_to root_path
    end
  end
  
  def reservation_params
    params.require(:reservation).permit(:request_date, :meal_ids, :adult_count,
                                :children_count, :allergies, :additional_message)
  end
  
  def load_booking_estimate
    meal_ids = params[:reservation][:meal_ids].split(',').map { |i| i.to_i }
    meals = Meal.find(meal_ids)
    meal_fees = meals.map(&:prep_fee_float).sum.round(2)
    @chef = Chef.find_by(id: meals.last.chef_id)
    @booking_rate = @chef.booking_rate.to_f + meal_fees
  end
  
end
