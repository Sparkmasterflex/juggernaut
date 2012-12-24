class PostsController < ApplicationController
  before_filter :authenticate_user!
  
  respond_to :html, :js, :json
  
  def index
    respond_with @posts = Post.all
  end
  
  def show
    respond_with @post = Post.find(params[:id]) 
  end
  
  def create
    @post = Post.create(params[:post].merge({:author_id => current_user.id}))
    respond_with @post
  end

  def update
    respond_with @post = Post.find(params[:id]).update_attributes(params[:post])
  end
end
