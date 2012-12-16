class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def get_csrf_token
    respond_to do |format|
      format.html { }
      format.json do
        token = form_authenticity_token
        render :json => {:token => token}
      end
    end
  end
end
