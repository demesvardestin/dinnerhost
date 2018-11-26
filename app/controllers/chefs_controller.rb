class ChefsController < ApplicationController
  before_action :set_cook
  before_action :authenticate_chef!, only: [:dashboard, :edit, :reservations]
  before_action :load_booking_estimate, only: [:booking_estimate, :reserve]
  
  def dashboard
  end
  
  def show
  end
  
  def edit
  end
  
  def update
    @cook.update(chef_params)
    respond_to do |format|
      if @cook.save
        format.html { redirect_to "/meals/2" }
      end
    end
  end
  
  def reservations
    @reservations = Reservation.where(chef_id: current_chef.id)
  end
  
  def accept_reservation
    @reservation = Reservation.find(params[:id])
    @cook.accept_reservation @reservation
    render :layout => false
  end
  
  def deny_reservation
    @reservation = Reservation.find(params[:id])
    @cook.deny_reservation @reservation
    render :layout => false
  end
  
  def all_accepted
    @accepted = Reservation.where(chef_id: current_chef.id).accepted
  end
  
  def denied
    @denied = Reservation.where(chef_id: current_chef.id).denied
  end
  
  def pending
    @pending = Reservation.where(chef_id: current_chef.id).pending
  end
  
  private
  
  def set_cook
    @cook = current_chef
  end
  
  def chef_params
    params.require(:chef)
    .permit(:first_name, :last_name, :phone_number, :twitter, :facebook, :instagram,
            :pinterest, :bio, :street_address, :town, :state, :zipcode, :booking_rate,
            :username, :image)
  end
  
end
