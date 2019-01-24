class PostsController < ApplicationController
	before_action :set_topic, only: [ :index, :new, :create,  :show, :edit, :update, :destroy ]
	before_action :set_post , only: [ :show, :edit, :update, :destroy]


	def index

		if params[:topic_id].nil?
			@posts = Post.topic_post.paginate(page: params[:page], per_page: 10).includes(:topic).eager_load(:ratings).eager_load(:comments)
		else
			@posts = @topic.posts.paginate(page: params[:page], per_page: 10).eager_load(:ratings).eager_load(:comments)
		end

	end

	def new
		@post = @topic.posts.new
	end

	def create
		@post = @topic.posts.new(post_params)
		if @post.save
		    respond_to do |format|
		      format.html { redirect_to topic_posts_path(@topic), notice: 'Post was successfully created.' }
		    end
		else
			render action: :new, object: @tag
		end
	end

	def show
		@rating = Rating.new
		@ratings = @post.ratings
		@comments = @post.comments
		@comment = Comment.new
		@tag_relation = @post.tags
	end

	def destroy
		@post.destroy
	    respond_to do |format|
	      flash[:destroy] = 'Post was successfully destroyed.'
	      format.html { redirect_to topic_posts_path }
	      format.json { head :no_content }
	    end
	end

	def edit
	end

	def update
		if @post.update_attributes(post_params)
			flash[:notice] = 'Post was successfully updated.'
			redirect_to(topic_post_path(params[:topic_id],params[:id]))
		else
			render action: :edit
		end	
	end

	private

    def set_topic
			if not  params[:topic_id].blank?
				@topic = Topic.find(params[:topic_id])
				@tags = Tag.all
				end
    end

    def set_post
      @post = @topic.posts.find(params[:id])
    end

	def post_params
		params.require(:post).permit(:title,:body, tag_ids: [],tags_attributes: [:tag])
	end



end
