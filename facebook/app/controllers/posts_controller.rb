require "koala"
require "fbgraph"


class PostsController < ApplicationController

  def new
    @post = Post.new

    logger.info @facebook_cookies
    @user_graph = Koala::Facebook::API.new(@facebook_cookies['access_token'])
    pages = @user_graph.get_connections('me', 'accounts')
    page_token = @user_graph.get_page_access_token('131126613686117')
    @page_graph = Koala::Facebook::API.new(page_token) 
    profile = @page_graph.get_object('me')
    logger.info profile
  end

  def create
    begin
       @post = Post.new(params.require(:post).permit(:title, :text))
       @post.save
       redirect_to @post
    rescue
      logger.info "exception"
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def index
    @posts = Post.all
  end

end
