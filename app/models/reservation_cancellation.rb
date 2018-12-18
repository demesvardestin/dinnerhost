class ReservationCancellation < ApplicationRecord
    belongs_to :reservation
    belongs_to :customer
end
