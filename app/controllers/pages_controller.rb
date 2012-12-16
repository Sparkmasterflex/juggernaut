class PagesController < ApplicationController
  before_filter :authenticate_user!
  
  respond_to :html, :js, :json
  
  def index
    respond_with @pages = Page.all
  end
  
  def show
    respond_with @page = Page.find(params[:id]) 
  end
  
  def create
    @page = Page.create(params[:page].merge({:update_by => current_user.id}))
    respond_with @page
  end

  def update
    respond_with @page = Page.find(params[:id]).update_attributes(params[:page])
  end
end
