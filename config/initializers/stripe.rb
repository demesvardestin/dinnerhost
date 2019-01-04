if Rails.env == "development"
    Rails.configuration.stripe = {
        :publishable_key => "pk_test_4rlj7z7bgOSQVv1TrZAMhrJi",
        :secret_key      => "sk_test_QQfrtRFcrhpZnf9AIH8jJcXm"
    }
else
    Rails.configuration.stripe = {
        :publishable_key => ENV["STRIPE_PUBLISHABLE"],
        :secret_key      => ENV["STRIPE_SECRET"]
    }
end
Stripe.api_key = Rails.configuration.stripe[:secret_key]