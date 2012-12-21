class ImagesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_image, :except => [:index, :create]  
  
  respond_to :html, :js, :json
  
  def index
    respond_with @images = Image.where(:attachable_type => params[:attachable_type], :attachable_id => params[:attachable_id]).order(:item_order)
  end
  
  def show
    respond_with @image.to_json 
  end
  
  def create
    if remotipart_submitted?
      Rails.logger.info "==== attach_type: #{params[:image][:attachable_type]} ===="
      @parent = params[:image][:attachable_type].constantize.find(params[:image][:attachable_id])
      @image = Image.create(params[:image].merge(:item_order => @parent.images.size))
      respond_with(@image, :layout => false)
    end
  end
  
  def update
    respond_with @image.update_attributes(params[:image]).to_json
  end
  
  def reorder
    Image.reorder @image, params[:from], params[:to]
    respond_with @image
  end
  
  def destroy
    respond_with @image.destroy
  end
  
  private
  
  def get_image
    @image = Image.find(params[:id])
  end
end
