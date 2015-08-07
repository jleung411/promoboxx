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

#      if @post.save!
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
                                        :picture => '',
                                        :link => @post.link)
           end
           post_ids.push({:post_id => result[0]['id'], :page_name => page['name']})
         end

      logger.info @post['id']
      @post.save!
      redirect_to :controller => 'posts', :action => 'show', :id => 13, :post_ids => post_ids
    rescue => e
      logger.info 'exception'
      logger.info e
      logger.info e.message
#      if(e.fb_error_type == 'OAuthException')
        # Already Posted
#      end
      render new
    end
  end


  def show
    @post = Post.find(params[:id])
  end

  def index
    @posts = Post.all
  end

end
