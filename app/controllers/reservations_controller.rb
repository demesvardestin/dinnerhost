class ReservationsController < ApplicationController
  before_action :set_reservation, except: :start_reservation
  before_action :authorized_to_view, except: [:reserve, :booking_estimate, :start_reservation]
  before_action :authenticate_customer!, only: :start_reservation
  before_action :load_booking_estimate, only: [:update_reservation]
  before_action :unauthorized, only: :accepted
  
  def show
  end
  
  def start_reservation
    @cook = Chef.find_by(id: params[:id]) || Chef.find_by(username: params[:username]) || Chef.find_by(shortened_url: params[:shortened_url])
    @meal = Meal.find_by(id: params[:meal_id])
    meal_ids = if @meal
      @meal.id.to_s + ','
    else
      ''
    end
    @reservation = Reservation.create(
      customer_id: current_customer.id,
      chef_id: @cook.id,
      fee: "40.00",
      meal_ids: meal_ids
    )
    redirect_to "/book/#{@cook.username}/#{@reservation.id}/?meal_ids=#{@reservation.meal_ids}&request_date=&request_time=Time&adult_count=1&children_count=0&allergies="
  end
  
  def book
    @cook = Chef.find_by(username: params[:username])
    @reservation = Reservation.find_by(id: params[:id])
  end
  
  def booking_estimate
    render :layout => false
  end
  
  def update_reservation
    params[:reservation][:fee] = @booking_rate
    @reservation = Reservation.find(params[:reservation][:id])
    @reservation.update(reservation_params)
    
    render :layout => false
  end
  
  def reserve
    @reservation = Reservation.find_by(id: params[:reservation][:id])
    redirect_to "/booking/confirmation/#{@reservation.id}"
  end
  
  def complete_reservation
    params[:reservation][:active] = true
    @reservation.update(reservation_params)
    respond_to do |format|
      if @reservation.save
        @reservation.generate_reservation_token
        
        UserMailer.new_reservation_request(@reservation).deliver_now
        MessageUpdate.new_reservation_request(@reservation)
        create_initial_message(@reservation.chef, @reservation.additional_message) if !@reservation.additional_message.empty?
        format.html { redirect_to "/booking-complete?reservation=#{@reservation.id}" }
      end
    end
  end
  
  def booking_complete
    if check_active == false
      redirect_to _404_
      return
    end
    
    if @reservation.accepted
      redirect_to "/booking-accepted?reservation=#{@reservation.id}"
      return
    end
    
    @chef = @reservation.chef
    
    unless @reservation.diner_alerted
      UserMailer.booking_complete(@reservation).deliver_now
      MessageUpdate.booking_complete(@reservation)
      
      @reservation.update(diner_alerted: true, diner_alerted_on: Time.zone.now, diner_alerts_sent: 1)
    end
  end
  
  def booking_accepted
    if check_active == false
      redirect_to _404_
      return
    end
    
    if !@reservation.accepted
      redirect_to "/booking-complete?reservation=#{@reservation.id}"
      return
    end
    
    @chef = @reservation.chef
  end
  
  def booking_confirmation
    @cook = @reservation.chef
    if @reservation.active
      redirect_to "/booking-complete?reservation=#{@reservation.id}"
    end
  end
  
  def create_initial_message(cook, message_content)
    @conversation = Conversation.find_by(chef_id: cook.id, customer_id: current_customer.id)
    if @conversation.nil?
      @conversation = Conversation.create(
                        chef_id: cook.id,
                        customer_id: current_customer.id,
                        last_accessed: Time.zone.now,
                        last_accessed_by_user_type: current_customer.user_type)
    end
    @message = Message.create(
                content: message_content,
                sender_type: "customer",
                customer_id: current_customer.id,
                chef_id: cook.id,
                conversation_id: @conversation.id)
    MessageUpdate.alert_receiver @message, @message.sender, @message.receiver
    return @conversation
  end
  
  def cancel_reservation
    @reservation = Reservation.find_by(id: params[:id])
    if !@reservation || @reservation.customer != current_customer
      return
    end
    
    @cancel = ReservationCancellation.new(cancel_params)
    @cancel.customer = current_customer
    @cancel.reservation = @reservation
    respond_to do |format|
      if @cancel.save
        @reservation.update(cancelled: true, cancelled_on: Time.zone.now)
        @notice = "Reservation cancelled!"
        format.js { render "reservation_cancelled", :layout => false }
      end
    end
  end
  
  private
  
  def set_reservation
    @reservation = Reservation.find_by(id: params[:id]) || Reservation.find_by(id: params[:reservation]) || Reservation.find_by(id: params[:reservation][:id])
  end
  
  def unauthorized
    redirect_to root_path if (@cook != @reservation.chef || current_chef.nil?)
  end
  
  def user
    current_customer || current_chef
  end
  
  def authorized_to_view
    set_reservation
    if current_customer
      if !(@reservation.customer == current_customer)
        redirect_to _404_
      end
    else
      authenticate_customer!
    end
  end
  
  def check_active
    set_reservation
    ret = true
    
    if !@reservation.active
      ret = false
    end
    
    ret
  end
  
  def reservation_params
    params.require(:reservation).permit(:request_date, :meal_ids, :adult_count,
                                :children_count, :allergies, :additional_message,
                                :request_time, :fee, :active)
  end
  
  def cancel_params
    params.require(:reservation_cancellation).permit(:reason)
  end
  
  def load_booking_estimate
    meal_ids = params[:reservation][:meal_ids].split(',').map { |i| i.to_i }
    meal_count = meal_ids.length
    people_count = params[:reservation][:adult_count].to_i > 2 ? (params[:reservation][:adult_count].to_i - 2) : 0
    people_fees = people_count * 15
    meal_fees = (meal_count - 1) * 5
    @chef = Chef.find_by(username: params[:reservation][:chef])
    @booking_rate = 40 + people_fees + meal_fees
  end
  
  def not_proper_user(obj)
    obj.user != user
  end
  
  def warn
    @notice = "Unauthorized Access!"
    render "common/unauthorized", :layout => false
  end
  
end
