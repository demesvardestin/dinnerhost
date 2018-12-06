class ChefsController < ApplicationController
  before_action :set_cook, except: :show
  before_action :authenticate_chef!, only: [:dashboard, :edit, :reservations]
  before_action :load_booking_estimate, only: [:booking_estimate, :reserve]
  before_action :load_reservations, except: [:show]
  
  def dashboard
  end
  
  def show
    @cook = Chef.find_by(id: params[:id]) || Chef.find_by(username: params[:username])
  end
  
  def edit
  end
  
  def update
    @cook.update(chef_params)
    respond_to do |format|
      if @cook.save
        format.js { render 'update_confirmation', :layout => false }
      else
        format.js { render 'update_failed', :layout => false }
      end
    end
  end
  
  def reservations
    @status = "pending"
  end
  
  def accept_reservation
    @reservation = Reservation.find(params[:id])
    @cook.accept_reservation @reservation
    render :layout => false
  end
  
  def deny_reservation
    @reservation = Reservation.find(params[:id])
    @pending = Reservation.where(chef_id: current_chef.id).pending
    @cook.deny_reservation @reservation
    render :layout => false
  end
  
  def all_accepted
    @status = "accepted"
    @accepted = Reservation.where(chef_id: current_chef.id).accepted
  end
  
  def denied
    @status = "denied"
    @denied = Reservation.where(chef_id: current_chef.id).denied
  end
  
  def pending
    @status = "pending"
    @pending = Reservation.where(chef_id: current_chef.id).pending
  end
  
  private
  
  def set_cook
    @cook = current_chef
  end
  
  def load_reservations
    @reservations = Reservation.where(chef_id: current_chef.id)
    @accepted = @reservations.accepted.reverse
    @denied = @reservations.denied.reverse
    @pending = @reservations.pending.reverse
  end
  
  def chef_params
    params
    .require(:chef)
    .permit(:first_name, :last_name, :phone_number, :twitter, :facebook, :instagram,
            :pinterest, :bio, :street_address, :town, :state, :zipcode, :booking_rate,
            :username, :image)
  end
  
end
