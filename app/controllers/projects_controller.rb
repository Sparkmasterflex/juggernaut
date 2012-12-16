class ProjectsController < ApplicationController
  before_filter :authenticate_user!
  
  respond_to :html, :js, :json
  
  def index
    respond_with @projects = Project.all
  end
  
  def show
    respond_with @project = Project.find(params[:id]) 
  end
  
  def create
    Rails.logger.info "==== params: #{params.inspect} ===="
    Rails.logger.info "==== params[:project]: #{params[:project].inspect} ===="
    @project = Project.create(params[:project].merge({:update_by => current_user.id}))
    respond_with @project
  end

  def update
    respond_with @project = Project.find(params[:id]).update_attributes(params[:project])
  end
end
