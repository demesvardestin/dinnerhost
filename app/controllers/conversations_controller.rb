class ConversationsController < ApplicationController
    before_action :authenticate_user, only: :inbox
    before_action :check_participants, only: :show
    
    def inbox
        @active = (current_chef || current_customer).conversations.not_archived(current_chef || current_customer)
        @archived = (current_chef || current_customer).conversations.archived(current_chef || current_customer)
    end
    
    def archive
        @conversation = Conversation.find_by(id: params[:id])
        archiver = current_customer ? "customer" : "chef"
        @conversation.update(archived_by: @conversation.archived_by << archiver)
        @active = (current_chef || current_customer).conversations.not_archived(current_chef || current_customer)
        @archived = (current_chef || current_customer).conversations.archived(current_chef || current_customer)
        render 'archive', :layout => false
    end
    
    def unarchive
        @conversation = Conversation.find_by(id: params[:id])
        archiver = current_customer ? "customer" : "chef"
        @conversation.update(archived_by: @conversation.archived_by.split(archiver).join(''))
        @active = (current_chef || current_customer).conversations.not_archived(current_chef || current_customer)
        @archived = (current_chef || current_customer).conversations.archived(current_chef || current_customer)
        render 'unarchive', :layout => false
    end
    
    def archived
        @archived = (current_chef || current_customer).conversations.archived(current_chef || current_customer)
        render :layout => false
    end
    
    def all
        @active = (current_chef || current_customer).conversations.not_archived(current_chef || current_customer)
        render :layout => false
    end
    
    def show
        @conversation = Conversation.find_by(id: params[:id])
        @conversation.update(last_accessed: Time.zone.now)
        @messages = @conversation.messages.reverse
        @message = Message.new
    end
    
    def create
        @conversation = Conversation.create(chef_id: params[:chef_id], customer_id: current_customer.id)
        redirect_to chat_path(:id => @conversation.id)
    end
    
    def create_message
        @message = Message.new(message_params)
        @conversation = Conversation.find_by(id: params[:conversation_id])
        @message.conversation_id = @conversation.id
        params[:message][:sender_type] == "customer" ? @message.customer_id = params["sender_id"] : @message.chef_id = params["sender_id"]
        respond_to do |format|
            if @message.save
                @messages = @conversation.messages.reverse
                format.js { render 'new_message', :layout => false }
            end
        end
    end
    
    private
    
    def message_params
        params.require(:message).permit(:content, :sender_type)
    end
    
    def check_participants
        @conversation = Conversation.find_by(id: params[:id])
        redirect_to root_path if !@conversation.participants.include?(current_chef || current_customer)
    end
    
    def authenticate_user
        current_customer ? authenticate_customer! : authenticate_chef!
    end
end
