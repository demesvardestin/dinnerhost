class PaymentProcessingJob < ApplicationJob
  queue_as :default

  def perform(reservation)
    ## Get details
    total = reservation.fee.to_f.to_i * 100
    fee = total * 0.15
    amount = (total - fee).to_i
    chef = reservation.chef
    
    ## Trigger transfer
    Stripe::Transfer.create(
      :amount => amount,
      :currency => "usd",
      :destination => chef.stripe_token,
      :transfer_group => "chef_payout"
    )
    
    ## On failure, log error. Manually resolve it later
    rescue Stripe::InvalidRequestError => e
    
    AppError.create(
      error_type: "Stripe > Chef Payout",
      details: e,
      object_type: "Reservation",
      object_id: reservation.id
    )
  end
end
