class Cart < ActiveRecord::Base
    
    has_one :order
    
    def add_item(id, count, price, size, name, taxable)
        item_list = self.item_list
        item_list_count = self.item_list_count
        items_price_list = self.items_price_list
        item_list_name = self.item_list_name
        item_tax_list = self.item_tax_list
        if self.item_list == ''
            self.update(
                item_list: item_list << id,
                item_list_count: item_list_count << count,
                items_price_list: items_price_list << price,
                item_list_name: item_list_name << name + ' - ' + size,
                item_tax_list: item_tax_list << taxable
            )
        else
            self.update(
                item_list: item_list << ', ' + id,
                item_list_count: item_list_count << ', ' + count,
                items_price_list: items_price_list << ', ' + price,
                item_list_name: item_list_name << ', ' + name + ' - ' + size,
                item_tax_list: item_tax_list << ', ' + taxable
            )
        end
        total_cost = 0.0
        self.item_list.split(', ').each_with_index do |i, idx|
            total_cost += (self.items_price_list.split(', ')[idx].to_f * self.item_list_count.split(', ')[idx].to_i)
        end
        self.update(total_cost: total_cost.to_s)
    end
    
    def remove_item(item_id)
        index = self.item_list.split(', ').index("#{item_id}")
        new_item_list = self.item_list.split(', ')
        new_item_list.delete("#{item_id}")
        new_item_list = new_item_list.join(', ')
        new_item_list_count = self.item_list_count.split(', ')
        new_item_list_count.delete_at(index)
        new_item_list_count = new_item_list_count.join(', ')
        new_items_price_list = self.items_price_list.split(', ')
        new_items_price_list.delete_at(index)
        new_items_price_list = new_items_price_list.join(', ')
        new_item_list_name = self.item_list_name.split(', ')
        new_item_list_name.delete_at(index)
        new_item_list_name = new_item_list_name.join(', ')
        new_item_tax_list = self.item_tax_list.split(', ')
        new_item_tax_list.delete_at(index)
        new_item_tax_list = new_item_tax_list.join(', ')
        total_cost = 0.0
        new_item_list.split(', ').each_with_index do |i, idx|
            total_cost += (new_items_price_list.split(', ')[idx].to_f * new_item_list_count.split(', ')[idx].to_i)
        end
        self.update(
            item_list: new_item_list,
            item_list_count: new_item_list_count,
            items_price_list: new_items_price_list,
            item_list_name: new_item_list_name,
            item_tax_list: new_item_tax_list,
            total_cost: total_cost.to_s
        )
    end
    
    def clear_cart
        self.update(item_list: '', item_list_count: '', items_price_list: '', item_list_name: '', item_tax_list: '', total_cost: '0.0', store_id: nil, pending: true, shopper_email: '') 
    end
    
    def is_empty?
        return self.item_list == '' && self.item_list_count == '' && self.pending == true
    end
    
    def cost_for(item_id)
        index = self.item_list.split(', ').index(item_id)
        price = self.items_price_list.split(', ')[index]
        quantity = self.item_list_count.split(', ')[index]
        return (price.to_f * quantity.to_i).round(2)
    end
    
    def process_payment(token, address, phone_number, apt_number, email, delivery_option, delivery_instructions, contact_name, uid, day, time)
        shopper_email = self.shopper_email
        shopper_email.starts_with?('guest')? guest = true : guest = false
        store_id = self.get_store.id
        confirmation = self.generate_confirmation
        if delivery_option.downcase == 'delivery'
            total_amount = (self.final.round(2) * 100).to_i
            fee = ((self.get_taxes_and_fees - self.calculate_tax) * 100).to_i
            # cart.final - (cart.calculate_tax + cart.total_cost.to_f + cart.get_store.delivery_fee.to_f)
        else
            total_amount = (self.final_without_delivery.round(2) * 100).to_i
            fee = ((self.get_taxes_and_fees_without_delivery - self.calculate_tax) * 100).to_i
        end
        charge = Stripe::Charge.create(
            {
                :amount => total_amount,
                :currency => "usd",
                :source => token[:id],
                :description => "Order from cart ##{self.id}. Email: #{email}",
                :destination => {
                    :amount => total_amount - fee,
                    :account => self.get_store.stripe_cus,
                }
            }
        )
        order = Order.create(
            cart_id: self.id,
            store_id: store_id,
            shopper_email: shopper_email,
            guest: guest,
            item_list: self.item_list,
            item_list_count: self.item_list_count,
            total: ((total_amount / 100.to_f) - (fee / 100.to_f)),
            stripe_charge_id: charge.id,
            confirmation: confirmation.to_s,
            address: address,
            phone_number: phone_number,
            apartment_number: apt_number,
            ordered_at: Time.zone.now,
            online: true,
            delivered: false,
            processed: false,
            status: 'pending',
            delivery_email: email,
            contact_name: contact_name,
            delivery_option: delivery_option,
            shopper_uid: uid,
            delivery_day: day,
            delivery_time: time,
            delivery_instructions: delivery_instructions
        )
        self.update(order_id: order.id, completed: true, shopper_email: '')
    end
    
    def process_offline_payment(address, phone_number, apt_number, email, delivery_option, delivery_instructions, contact_name, uid, day, time)
        shopper_email = self.shopper_email
        shopper_email.starts_with?('guest')? guest = true : guest = false
        store_id = self.get_store.id
        confirmation = self.generate_confirmation
        if delivery_option.downcase == 'delivery'
            total_amount = (self.final_without_fee.round(2) * 100).to_i
        else
            total_amount = (self.final_without_delivery_and_without_fee.round(2) * 100).to_i
        end
        order = Order.create(
            cart_id: self.id,
            store_id: store_id,
            shopper_email: shopper_email,
            guest: guest,
            item_list: self.item_list,
            item_list_count: self.item_list_count,
            total: (total_amount / 100.to_f),
            confirmation: confirmation.to_s,
            address: address,
            phone_number: phone_number,
            apartment_number: apt_number,
            ordered_at: Time.zone.now,
            online: true,
            delivered: false,
            processed: false,
            status: 'pending',
            delivery_email: email,
            contact_name: contact_name,
            delivery_option: delivery_option,
            shopper_uid: uid,
            delivery_day: day,
            delivery_time: time,
            delivery_instructions: delivery_instructions,
            payment_type: 'in person'
        )
        self.update(order_id: order.id, completed: true, shopper_email: '')
    end
    
    def calculate_tip(tip=nil)
       tip.nil? ? tip = self.tip.split('%').join('') : tip.split('%').join('')
       tip_amount = (((self.get_total_cost + self.calculate_tax) * tip.to_i)/100).round(2)
       total = (self.get_total_cost + self.calculate_tax) + tip_amount
       self.update(final_amount: total, tip_amount: tip_amount, tip: tip)
    end
    
    def generate_confirmation
        conf = rand(1000000..9999999)
        until !Order.exists?(confirmation: conf)
            return self.generate_confirmation
        end
        conf
    end
    
    def item_count
        count = 0
        self.item_list_count.split(', ').each do |i|
            count += i.to_i
        end
        count
    end
    
    def total(item)
        index = self.item_list.split(', ').index("#{item}")
        return self.item_list_count.split(', ')[index]
    end
    
    def get_total_cost
        self.total_cost.to_f.round(2)
    end
    
    def calculate_tax
        tax_total = 0.0
        self.item_list.split(', ').each_with_index do |i, idx|
            taxable = self.item_tax_list.split(', ')[idx].downcase
            if taxable == 'yes' && self.get_store.state.downcase.include?('ny')
                tax_total += (self.items_price_list.split(', ')[idx].to_f * 0.08875 * self.item_list_count.split(', ')[idx].to_i).round(2)
            elsif self.get_store.state.downcase.include?('ma')
                tax_total += (self.items_price_list.split(', ')[idx].to_f * 0.05 * self.item_list_count.split(', ')[idx].to_i).round(2)
            end
        end
        return tax_total
    end
    
    def get_tip
        if self.tip_amount.to_f == 0
            tip = (((self.get_total_cost + self.calculate_tax) * self.tip.to_i)/100).round(2)
            self.update(tip_amount: tip)
        else
            tip = self.tip_amount.to_f
        end
        return tip
    end
    
    def final_algo(opt1=0.0, opt2=0.0, opt3=0.0)
        
    end
    
    def calculate_final(delivery_type=nil)
        option = delivery_type.downcase
        if option && option == 'delivery'
            if self.get_store.has_a_bank_account
                self.final
            else
                self.final_without_fee
            end
        else
            if self.get_store.has_a_bank_account
                self.final_without_delivery
            else
                self.final_without_delivery_and_without_fee
            end
        end
    end
    
    def calculate_fees(delivery_type=nil)
        option = delivery_type.downcase
        if option && option == 'delivery'
            if self.get_store.has_a_bank_account
                self.calculate_tax + ((self.calculate_tax + self.total_cost.to_f + self.get_store.delivery_fee.to_f) * 0.05)
            else
                self.calculate_tax
            end
        else
            if self.get_store.has_a_bank_account
                self.calculate_tax + ((self.calculate_tax + self.total_cost.to_f) * 0.05)
            else
                self.calculate_tax
            end
        end
    end
    
    def final
        if self.get_store.delivers_for_free
            self.calculate_tax.round(2) + self.total_cost.to_f.round(2) + ((self.calculate_tax.round(2) + self.total_cost.to_f.round(2)) * 0.05).round(2)
        else
            self.calculate_tax.round(2) + self.total_cost.to_f.round(2) + self.get_store.delivery_fee.to_f + ((self.get_store.delivery_fee.to_f + self.calculate_tax.round(2) + self.total_cost.to_f.round(2)) * 0.05).round(2)
        end
    end
    
    def final_without_fee
        if self.get_store.delivers_for_free
            self.calculate_tax.round(2) + self.total_cost.to_f.round(2)
        else
            self.calculate_tax.round(2) + self.total_cost.to_f.round(2) + self.get_store.delivery_fee.to_f
        end
    end
    
    def get_taxes_and_fees
        self.calculate_tax.round(2) + ((self.get_store.delivery_fee.to_f + self.calculate_tax.round(2) + self.total_cost.to_f.round(2)) * 0.05).round(2)
    end
    
    def get_taxes_and_fees_without_delivery
        self.calculate_tax.round(2) + ((self.calculate_tax.round(2) + self.total_cost.to_f.round(2)) * 0.05).round(2)
    end
    
    def get_taxes_and_fees_without_delivery_without_fee
        self.calculate_tax.round(2)
    end
    
    def final_without_delivery
        self.calculate_tax.round(2) + self.total_cost.to_f.round(2) + ((self.calculate_tax.round(2) + self.total_cost.to_f.round(2)) * 0.05).round(2)
    end
    
    def final_without_delivery_and_without_fee
        self.calculate_tax.round(2) + self.total_cost.to_f.round(2)
    end
    
    def get_store
        return Store.find_by(id: self.store_id) 
    end
    
    def sale_total
        self.final_amount.nil? ? final = 0.0 : final = self.final_amount
        (self.get_total_cost + self.calculate_tax).round(2)
    end
    
    def item_list_array
        self.item_list.split(', ') 
    end
    
    def item_list_count_array
        self.item_list_count.split(', ') 
    end
    
    def instruction_list_array
        self.instructions_list.split(', ') 
    end
end