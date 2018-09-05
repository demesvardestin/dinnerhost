class StoresController < ApplicationController
    before_action :set_store
    before_action :authenticate_store!,
                                    only: [:show, :update, :edit_profile,
                                        :edit_hours, :dashboard, :earnings,
                                        :update_sessions_count, :add_new_item,
                                         :add_data_to_firestore, :inventory]
    
    def dashboard
        
    end
    
    def inventory
         
    end
    
    def add_data_to_firestore
        render :layout => false 
    end
    
    def add_new_item
        render :layout => false 
    end
    
    def earnings
        
    end
    
    def show
        
    end
    
    def edit_profile
        
    end
    
    def edit_hours
        
    end
    
    def update
        
    end
    
    def update_sessions_count
        sessions_count =  @store.sessions_count
        @store.update(sessions_count: sessions_count + 1)
    end
    
    private
    
    def set_store
        @store = current_store 
    end
    
    def stores_params
        params.require(:store).permit(:email, :street_address, :town, :state, :zipcode, :name, :phone, :supervisor, :website) 
    end
end