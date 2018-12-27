
class ConversationsController < ApplicationController
    before_action :authenticate_user, only: :inbox
    before_action :user
    before_action :check_participants, only: :show
    before_action :check_archives, only: [:archive, :unarchive, :inbox]
    
    def inbox
    end
    
    def archive
        @conversation = Conversation.find_by(id: params[:id])
        archiver = current_customer ? "customer" : "chef"
        @conversation.update(archived_by: @conversation.archived_by << archiver)
        render 'archive', :layout => false
    end
    
    def unarchive
        @conversation = Conversation.find_by(id: params[:id])
        archiver = current_customer ? "customer" : "chef"
        @conversation.update(archived_by: @conversation.archived_by.split(archiver).join(''))
        render 'unarchive', :layout => false
    end
    
    def archived
        @archived = @user.conversations.archived(@user).order("updated_at DESC")
        render :layout => false
    end
    
    def all
        @active = @user.conversations.not_archived(@user).order("updated_at DESC")
        render :layout => false
    end
    
    def show
        @conversation = Conversation.find_by(id: params[:id])
        @conversation.update(last_accessed: Time.zone.now, last_accessed_by_user_type: @user.user_type)
        @message = Message.new
        @messages = @conversation.messages.reverse
    end
    
    def create
        @conversation = Conversation.create(chef_id: params[:chef_id], customer_id: current_customer.id)
        redirect_to chat_path(:id => @conversation.id)
    end
    
    def contact_customer
        @conversation = Conversation.create(chef_id: current_chef.id, customer_id: params[:customer_id])
        redirect_to chat_path(:id => @conversation.id)
    end
    
    def create_message
        @message = Message.new(message_params)
        @conversation = Conversation.find_by(id: params[:conversation_id])
        @message.conversation_id = @conversation.id
        @message.sender_type == "customer" ? @message.customer_id = params["sender_id"] : @message.chef_id = params["sender_id"]
        respond_to do |format|
            if @message.save
                @messages = @conversation.messages.reverse
                format.js { render 'new_message', :layout => false }
                MessageUpdate.alert_receiver @message, @message.sender, @message.receiver
            end
        end
    end
    
    private
    
    def message_params
        params.require(:message).permit(:content, :sender_type)
    end
    
    def user
        @user = (current_customer || current_chef)
    end
    
    def check_participants
        @conversation = Conversation.find_by(id: params[:id])
        redirect_to root_path if !@conversation.participants.include? @user
    end
    
    def authenticate_user
        # current_customer ? authenticate_customer! : authenticate_chef!
        if !user
            redirect_to user_type_path
        end
    end
    
    def check_archives
        @user = user
        @active = @user.conversations.not_archived(@user).sort_by(&:last_message).reverse
        @archived = @user.conversations.archived(@user)
    end
end
