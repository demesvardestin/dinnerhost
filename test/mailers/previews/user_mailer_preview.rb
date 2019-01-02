class UserMailerPreview < ActionMailer::Preview
  def welcome_email
    UserMailer.welcome_email(Chef.first)
  end
  
  def new_reservation_request
      UserMailer.new_reservation_request(Reservation.last)
  end
  
  def reservation_accepted
      UserMailer.reservation_accepted(Reservation.last)
  end
  
  def reservation_denied
      UserMailer.reservation_denied(Reservation.last)
  end
  
  def booking_complete
      UserMailer.booking_complete(Reservation.last)
  end
  
  def invite_chef
      UserMailer.invite_chef("dddemesvar07@gmail.com", Customer.last)
  end
end