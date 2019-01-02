class MessagingJob < ApplicationJob
  queue_as :default

  def perform(reservation)
    
    MessageUpdate.send_booking_reminder_to_chef reservation
    MessageUpdate.send_booking_reminder_to_customer reservation
    
    ## On failure, log error. Manually resolve it later
    rescue
    
    AppError.create(
      error_type: "Booking Reminder",
      details: e,
      object_type: "Reservation",
      object_id: reservation.id
    )
  end
end
