class ImagesController < ApplicationController
  before_filter :authenticate_user!
  
  respond_to :html, :js, :json
  
  def index
    Rails.logger.info "==== params: #{params.inspect} ===="
    @object = params[:attachable_type].constantize.find(params[:attachable_id])
    respond_with @images = @object.images
  end
  
  def show
    respond_with @image = Image.find(params[:id]) 
  end
  
  def create
    if remotipart_submitted?
      @image = Image.create(params[:image])
      respond_with(@image, :layout => false)
    end
  end
  
  def destroy
    @image = Image.find(params[:id])
    respond_with @image.destroy
  end
end
