class ShopperMailerPreview < ActionMailer::Preview
  # Accessible from http://localhost:3000/rails/mailers/notifier/welcome
  def order_receipt
    ShopperMailer.order_receipt(Order.last.delivery_email, Cart.where(pending: true).last, Order.last)
  end
end