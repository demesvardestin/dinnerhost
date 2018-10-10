module StoresHelper
    
    def hours
        ['Closed', '12:00AM', '12:30AM', '1:00AM', '1:30AM', '2:00AM', '2:30AM', '3:00AM', '3:30AM', '4:00AM', '4:30AM', '5:00AM', '5:30AM', '6:00AM', '6:30AM',
        '7:00AM', '7:30AM', '8:00AM', '8:30AM', '9:00AM', '9:30AM', '10:00AM', '10:30AM', '11:00AM', '11:30AM', '12:00PM', '12:30PM', '1:00PM', '1:30PM',
        '2:00PM', '2:30PM', '3:00PM', '3:30PM', '4:00PM', '4:30PM', '5:00PM', '5:30PM', '6:00PM', '6:30PM',
        '7:00PM', '7:30PM', '8:00PM', '8:30PM', '9:00PM', '9:30PM', '10:00PM', '10:30PM', '11:00PM', '11:30PM'] 
    end
    
    def checkout_link
        "/#{current_cart.id}/checkout?cart_id=#{@token}&shopper=true&guest=false&senzzu_token=#{request.remote_ip}" 
    end
    
    def delivery_tag(store)
        if store.delivery_fee == '0.00'
            'free delivery'
        else
            '$' + store.delivery_fee + ' delivery fee'
        end 
    end
    
    def current_cart
        @cart = Cart.where(shopper_email: request.remote_ip, pending: true).last
        if @cart.nil?
            @cart = Cart.create(shopper_email: request.remote_ip, pending: true)
        end
        return @cart
    end
    
    def current_day?(day)
        if Date.today.strftime("%A").include? day[0..3]
            'bold'
        end
    end
    
    def store_is_closed(store)
        if !Date.today.strftime("%A").downcase.include?('sat') || !Date.today.strftime("%A").downcase.include?('sun')
            if store.weekday_hours == 'Closed' || (Time.zone.now - 4.hours) > ((Time.zone.now.strftime('20%y-%m-%d ') + store.weekday_hours.upcase[-7..-1].strip).to_datetime)
                'show'
            end
        elsif Date.today.strftime("%A").downcase.include?('sat')
            if store.saturday_hours == 'Closed' || (Time.zone.now - 4.hours) > ((Time.zone.now.strftime('20%y-%m-%d ') + store.saturday_hours.upcase[-7..-1].strip).to_datetime)
                'show'
            end
        elsif Date.today.strftime("%A").downcase.include?('sun')
            if store.sunday_hours == 'Closed' || (Time.zone.now - 4.hours) > ((Time.zone.now.strftime('20%y-%m-%d ') + store.sunday_hours.upcase[-7..-1].strip).to_datetime)
                'show'
            end
        end
    end
    
    def new_orders
        current_store.unprocessed_orders
    end
    
    def processed_orders
        current_store.completed_orders
    end
    
    def total_earnings
        current_store.all_orders.sum(&:total_cost).round(2)
    end
    
    def today_earnings
        current_store.all_orders.where(created_at: DateTime.now.at_beginning_of_day.utc..Time.now.utc).sum(&:total_cost)
    end
    
    def store_earnings
        map = {}
        current_store.all_orders.group_by_day(:created_at).count.each { |o|
            map[o[0]] = current_store.all_orders.where("strftime('%Y-%m-%d', created_at) = ?", "#{o[0]}").total_earnings
        }
        map
    end
    
    def week_orders
        current_store.all_orders.week
    end
    
    def month_orders
        current_store.all_orders.month
    end
    
    def year_orders
        current_store.all_orders.year
    end
    
    def all_orders
        current_store.all_orders 
    end
    
    def week_volume
        week_orders.sum(&:total_cost).round(2)
    end
    
    def month_volume
        month_orders.sum(&:total_cost).round(2)
    end
    
    def year_volume
        year_orders.sum(&:total_cost).round(2)
    end
    
    def all_volume
        all_orders.sum(&:total_cost).round(2)
    end
    
    def week_orders_graph
        week_orders.group_by_day(:created_at).count
    end
    
    def month_orders_graph
        month_orders.group_by_week(:created_at).count
    end
    
    def year_orders_graph
        year_orders.group_by_month(:created_at).count
    end
    
    def all_orders_graph
        all_orders.group_by_month(:created_at).count
    end
    
    def week_sales_graph
        map = {}
        week_orders.group_by_day(:created_at).count.each { |o|
            map[o[0]] = current_store.all_orders.where("strftime('%Y-%m-%d', created_at) = ?", "#{o[0]}").total_earnings
        }
        map
    end
    
    def month_sales_graph
        map = {}
        month_orders.group_by_week(:created_at).count.each { |o|
            map[o[0]] = current_store.all_orders.where("strftime('%Y-%m-%d', created_at) = ?", "#{o[0]}").total_earnings
        }
        map
    end
    
    def year_sales_graph
        map = {}
        year_orders.group_by_month(:created_at).count.each { |o|
            map[o[0]] = current_store.all_orders.where("strftime('%Y-%m-%d', created_at) = ?", "#{o[0]}").total_earnings
        }
        map
    end
    
    def all_sales_graph
        map = {}
        all_orders.group_by_month(:created_at).count.each { |o|
            map[o[0]] = current_store.all_orders.where("strftime('%Y-%m-%d', created_at) = ?", "#{o[0]}").total_earnings
        }
        map
    end
    
end