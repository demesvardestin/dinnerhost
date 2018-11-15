module ConversationsHelper
    
    def message_text_alignment(type)
        if type == "chef"
            if current_chef
                "text-right"
            end
        else
            if current_customer
                "text-right"
            end
        end
    end
    
    def message_box_alignment(type)
        if type == "chef"
            if current_chef
                "float-right current-sender"
            else
                "float-left"
            end
        else
            if current_customer
                "float-right current-sender"
            else
                "float-left"
            end
        end
    end
    
    def message_sender_alignment(type, side)
        if message_box_alignment(type) == "float-right"
            if side == "left"
                "no-display"
            else
                "float-left"
            end
        elsif message_box_alignment(type) == "float-left"
            if side == "right"
                "no-display"
            else
                "float-right"
            end
        end
    end
    
    def current_sender
        if current_chef
            current_chef
        else
            current_customer
        end
    end
    
    def messagee(chef_id, customer_id)
        if current_chef
            Customer.find_by(id: customer_id)
        else
            Chef.find_by(id: chef_id)
        end
    end
    
    def new_message?(message)
        message.conversation.last_accessed_by_user_type != user.user_type && message.created_at > message.conversation.last_accessed.to_datetime
    end
    
    def message_snipet_color(message)
        if new_message? message
            ""
        else
            "text-muted"
        end
    end
    
end
