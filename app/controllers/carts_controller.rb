class CartsController < ApplicationController
  
  before_action :check_empty, only: [:confirmation]
  before_action :check_completed, only: [:confirmation]
  before_action :check_owner, only: [:show]
  before_action :order_placed, only: [:show]
  
  def show
    @cart = Cart.find_by(id: params[:id])
    if @cart.completed
      redirect_to root_path
    end
  end
  
  def confirmation
    @cart = Cart.find(params[:id])
    @order = Order.find_by(cart_id: @cart.id)
  end
  
  def track_order_status
    order = params[:order_number]
    @order = Order.find_by(confirmation: order)
    if @order.nil?
      @status = 'not found'
      @text = 'We were unable to find this order.'
      render :layout => false
      return
    end
    case @order.status
    when 'pending'
      @status = 'received'
      @text = 'Your order has been received by the store!'
    when 'ready for delivery'
      @status = 'ready'
      @text = 'Your order has been prepared and is pending delivery!'
    when 'ready for pickup'
      @status = 'ready'
      @text = 'Your order is ready for pickup!'
    when 'picked up'
      @status = 'picked up'
      @text = 'You have picked up your order!'
    when 'delivered'
      @status = 'in transit'
      @text = 'Your delivery is on the way!'
    when 'cancelled'
      @status = 'cancelled'
      @text = "Your order has been cancelled. Please contact us if you haven't received a refund"
    else
      @status = 'no status'
      @text = "Please contact the store at #{Store.find_by(id: @order.pharmacy_id).number}."
    end
    render :layout => false
  end
  
  def reorder
    cart_id = params[:cart_id]
    @old_cart = Cart.find_by(id: cart_id)
    @new_cart = Cart.where(shopper_email: request.remote_ip, pending: true).last
    if @new_cart.nil?
      @new_cart = Cart.create(
        shopper_email: request.remote_ip,
        pending: true,
        total_cost: @old_cart.total_cost,
        item_list: @old_cart.item_list,
        item_list_count: @old_cart.item_list_count,
        store_id: @old_cart.store_id,
        paid: false,
        items_price_list: @old_cart.items_price_list,
        item_list_name: @old_cart.item_list_name,
        item_tax_list: @old_cart.item_tax_list
      )
    else
      @new_cart.update(
        shopper_email: request.remote_ip,
        pending: true,
        total_cost: @old_cart.total_cost,
        item_list: @old_cart.item_list,
        item_list_count: @old_cart.item_list_count,
        store_id: @old_cart.store_id,
        paid: false,
        items_price_list: @old_cart.items_price_list,
        item_list_name: @old_cart.item_list_name,
        item_tax_list: @old_cart.item_tax_list
      )
    end
    render :layout => false
  end
  
  def add_item
    cart = params[:cart]
    @item_id = cart[:item_id]
    @cart = Cart.where(shopper_email: request.remote_ip, pending: true).last
    if @cart.item_list.empty?
      @cart.update(store_id: cart[:store_id], shopper_id: params[:shopper_id])
    end
    @cart.add_item(cart[:item_id], cart[:item_count], cart[:item_price], cart[:item_size], cart[:item_name].strip!, cart[:item_taxable])
  end
  
  def change_delivery_type
    @cart = Cart.where(shopper_email: request.remote_ip, pending: true).last
    @type = params[:type].downcase
    render :layout => false
  end
  
  def remove_item
    cart = params[:cart]
    @item_id = cart[:item_id]
    @cart = Cart.where(shopper_email: request.remote_ip, pending: true).last
    @total = @cart.total(@item_id)
    @cart.remove_item(@item_id)
  end
  
  def clear_cart
    @cart = Cart.where(shopper_email: params[:cart][:shopper_email], pending: true).last
    @cart.clear_cart
    render :layout => false
  end
  
  def process_offline_order
    guest = request.remote_ip
    @cart = Cart.find_by(id: params[:cart][:id])
    if guest != params[:cart][:guest_shopper] || @cart.get_store.has_a_bank_account || params[:cart][:guest_shopper].empty?
      render 'unauthorized', :layout => false
      return
    end
    begin
      @token = params[:cart][:token]
      @email = params[:cart][:email]
      @address = params[:cart][:address]
      @phone = params[:cart][:phone_number]
      @apt_number = params[:cart][:apt_number]
      @delivery_option = params[:cart][:delivery_option]
      @delivery_instructions = params[:cart][:delivery_instructions]
      @contact_name = params[:cart][:contact_name]
      @uid = params[:cart][:uid]
      @day = params[:cart][:day]
      @time = params[:cart][:time]
      @cart.process_offline_payment(@address, @phone, @apt_number, @email, @delivery_option, @delivery_instructions, @contact_name, @uid, @day, @time)
      @order = Order.find_by(cart_id: @cart.id)
      @confirmation = @order.confirmation
    rescue
      render 'process_error', :layout => false
      return
    end
    @message = "Thank you for ordering on Senzzu! Your request has been received by #{@cart.get_store.name} and will be processed soon!"
    # MessageUpdate.alert_customer(@phone, @message)
    ShopperMailer.order_receipt(@email, @cart, @order)
    render :layout => false
  end
  
  def submit_order
    guest = request.remote_ip
    if guest != params[:cart][:guest_shopper] || params[:cart][:stripe_token].blank? || params[:cart][:stripe_token].nil? || params[:cart][:guest_shopper].empty?
      render 'unauthorized', :layout => false
      return
    end
    begin
      @cart = Cart.find_by(id: params[:cart][:id])
      @token = params[:cart][:token]
      @email = params[:cart][:email]
      @address = params[:cart][:address]
      @phone = params[:cart][:phone_number]
      @apt_number = params[:cart][:apt_number]
      @delivery_option = params[:cart][:delivery_option]
      @delivery_instructions = params[:cart][:delivery_instructions]
      @contact_name = params[:cart][:contact_name]
      @uid = params[:cart][:uid]
      @day = params[:cart][:day]
      @time = params[:cart][:time]
      @cart.process_payment(params[:cart][:stripe_token], @address, @phone, @apt_number, @email, @delivery_option, @delivery_instructions, @contact_name, @uid, @day, @time)
      @order = Order.find_by(cart_id: @cart.id)
      @charge = @order.stripe_charge_id
      @confirmation = @order.confirmation
    rescue
      render 'process_error', :layout => false
      return
    end
    @message = "Thank you for ordering on Senzzu! Your request has been received by #{@cart.get_store.name} and will be processed soon!"
    MessageUpdate.alert_customer(@phone, @message)
    ShopperMailer.order_receipt(@email, @cart, @order)
    render :layout => false
  end
  
  def calculate_tip
    data = params[:data]
    tip = data[:tip]
    return if tip.nil?
    @cart = Cart.find_by(shopper_email: request.remote_ip)
    @cart.calculate_tip(tip)
    render :layout => false
  end
  
  def initiate_in_store_sale
    @cart = Cart.find_by(pharmacy_id: current_pharmacy.id, pending: true, completed: false, online: false)
    if @cart.nil?
      Cart.create(pharmacy_id: current_pharmacy.id, pending: true, completed: false, item_list: '', item_list_count: '', instructions_list: '', online: false)
    end
    render :layout => false
  end
  
  private
  
  def cart_params
    params.require(:cart).permit(:item_list, :item_list_count, :instructions_list, :shopper)
  end
  
  def check_completed
    @cart = Cart.find_by(id: params[:id])
    @order = Order.find_by(confirmation: params[:confirmation])
    redirect_to :back if @cart.nil? || @order.nil?
    if @cart.completed == false || @cart.completed.nil?
      redirect_to "#{@cart.get_store.url}"
    end
  end
  
  def order_placed
    @cart = Cart.find_by(id: params[:id])
    if @cart.completed
      redirect_to root_path
    end
  end
  
  def check_empty
    @cart = Cart.find_by(id: params[:id])
    if @cart.nil? || @cart.is_empty?
      redirect_to root_path, notice: 'You have not added any item to your cart yet'
    end
  end
  
  def check_owner
    if params[:senzzu_token] != request.remote_ip
      redirect_to root_path
    end
  end
end