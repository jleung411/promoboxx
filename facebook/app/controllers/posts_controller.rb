require "koala"
require "fbgraph"

# koala documents:
# https://github.com/arsduo/koala/wiki/Batch-requests
# https://github.com/arsduo/koala/wiki/Acting-as-a-Page

# notes:
# posting to pages as user
# posting to page as a page required FB to approve app


class PostsController < ApplicationController

  def new
    begin
      @post = Post.new
    rescue
      logger.info 'exception'
    end
  end

  def create
    begin
      @post = Post.new(params.require(:post).permit(:title, :description, :link, :message))

#         @user_graph= Koala::Facebook::API.new(@facebook_cookies['access_token'])
         @user_graph= Koala::Facebook::API.new('CAAF2ZB8JQo8sBANxbGLCZBrZB667HhhZCJ08ptWknVeHHfq2PEfI1GLghcwZAdoZAr2afeJ22RacqwKYQCBuQNhEnC4ZBrP98k6nNDbcHgFF8dL0epwV09TZBrk4KCl0xGQytVZCSLvjX5K0iDB7sZCNdtYZC2FojQg2mWHO2FDg5pUi6FyagHdtEvdrbS4cheAH2dFDngwKvhXpOfBbpuNSP4LnPr5G0GKUggZD')
         @pages = @user_graph.get_connections('me', 'accounts')

         post_ids = []

         for page in @pages
           @page_graph = Koala::Facebook::API.new(page['access_token'])
           result = @page_graph.batch do |batch_api|
              batch_api.put_connections('me', 'feed',
                                        :message => @post.message,
                                        :caption => @post.title,
                                        :description => @post.description,
                                        :name => @post.title,
                                        :picture => 'http://img2.wikia.nocookie.net/__cb20140418225113/clashofclans/images/1/14/Fight_Club_Edward_by_cromley009.jpg',
                                        :link => @post.link)
           end
           post_ids.push({:post_id => result[0]['id'], :page_name => page['name']})
         end

      logger.info @post['id']
      @post.save!
      redirect_to :controller => 'posts', :action => 'show', :id => 13, :post_ids => post_ids
    rescue Koala::Facebook::APIError => e
      logger.info 'exception: ' + e.fb_error_type
      logger.info 'exception: ' + e.fb_error_code.to_s
      logger.info 'exception: ' + e.fb_error_message
      if e.fb_error_user_msg
       logger.info 'exception: ' + e.fb_error_user_msg
      end
      if e.fb_error_user_title
        logger.info 'exception: ' + e.fb_error_user_title
      end
      redirect_to :controller => 'posts',
                  :action => 'index',
                  :error_type => e.fb_error_type,
                  :error_code => e.fb_error_code,
                  :error_message => e.fb_error_message
    end
  end


  def show
    @post = Post.find(params[:id])
  end

  def index
    @posts = Post.all
  end

end
