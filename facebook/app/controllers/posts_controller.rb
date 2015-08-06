require "koala"
require "fbgraph"

# koala documents:
# https://github.com/arsduo/koala/wiki/Batch-requests
# https://github.com/arsduo/koala/wiki/Acting-as-a-Page

class PostsController < ApplicationController

  def new
    @post = Post.new

    logger.info @facebook_cookies
    @user_graph = Koala::Facebook::API.new(@facebook_cookies['access_token'])
    pages = @user_graph.get_connections('me', 'accounts')

    for page in pages

      if page['name']
        next
      end 

      logger.info page
      logger.info page['access_token']
      @page_graph = Koala::Facebook::API.new(page['access_token']) 
      profile = @page_graph.get_object('me')
      logger.info profile

      @page_graph.put_wall_post('Hello there!', {
               'name' => 'Link name',
               'link' => 'http://www.example.com/',
               'caption' => '{*actor*} posted a new review',
               'description' => 'This is a longer description of the attachment',
               'picture' => 'http://www.example.com/thumbnail.jpg'
             })
    end
  end

  def create
    begin
       @post = Post.new(params.require(:post).permit(:title, :text))
       @post.save
       redirect_to @post
    rescue
      logger.info 'exception'
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def index
    @posts = Post.all
  end

end
