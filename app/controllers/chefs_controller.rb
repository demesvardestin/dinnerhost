class ChefsController < ApplicationController
  before_action :authenticate_chef!
  
  def dashboard
  end
  
end
