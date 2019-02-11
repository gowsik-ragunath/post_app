class PostsController < ApplicationController
	before_action :set_topic, only: [ :index, :new, :create,  :show, :edit, :update, :destroy, :read_status]
	before_action :set_post , only: [ :show, :edit, :update, :destroy,:read_status]
	load_and_authorize_resource
	skip_authorize_resource only: [:read_status, :rate_comment, :show_comment, :show_details]
	protect_from_forgery except: [:show_comment,:read_status, :show_details]


	def index
		if params[:topic_id].nil?
			@posts = Post.topic_post.paginate(page: params[:page], per_page: 10).includes(:topic).eager_load(:ratings).eager_load(:comments).includes(:posts_users).includes(:users)
		else
			@posts = @topic.posts.paginate(page: params[:page], per_page: 10).eager_load(:ratings).eager_load(:comments).includes(:posts_users).includes(:users)
		end

	end

	def new
		@post = @topic.posts.new
	end

	def create
		@post = @topic.posts.new(post_params.merge(user_id: current_user.id))
		respond_to do |format|
			if @post.save
				format.html { redirect_to topic_posts_path(@topic), notice:'Post was successfully created.' }
				format.json { render :new, status: :created }
				format.js
			else
				flash.now[:error] = @post.errors.full_messages if @post.errors.any?
				format.js
				format.html { render :new, object: @tag }
				format.json { render json: @post.errors, status: :unprocessable_entity }
			end
		end
	end

	def show
		@rating = Rating.new
		@ratings = @post.ratings.rating_order
		@check_rating = check_rating_order(@ratings)
		@comments = @post.comments.eager_load(:user)
		@comment = Comment.new
		@comment_rating = UserCommentRating.new
		@tag_relation = @post.tags
	end

	def rate_comment
		if current_user
			UserCommentRating.create!(user_id: current_user.id,comment_id: params[:comment_id],rating: params[:rating])
		end
		respond_to do |format|
			format.js
			format.html { redirect_to topic_post_path(params[:topic_id],params[:id]) }
		end
	end

	def show_comment
		@check =  UserCommentRating.where(comment_id: params[:comment])
		respond_to do |format|
			format.js
			format.html { redirect_to topic_post_path(params[:topic_id],params[:id])}
		end
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
		if @post.update_attributes(post_params.merge(user_id: current_user.id))
			flash[:notice] = 'Post was successfully updated.'
			redirect_to(topic_post_path(params[:topic_id],params[:id]))
		else
			render action: :edit
		end	
	end

	def read_status
		respond_to do |format|
      unless @post.users.include?(current_user)
        @post.users << current_user
      end
			format.js
		end
  end

  def show_details
    @posts =  Post.overlapping(params[:datetime_from],params[:datetime_to])
    respond_to do |format|
      format.js
    end
  end

	private

    def set_topic
			if not params[:topic_id].blank?
				@topic = Topic.find(params[:topic_id])
				@tags = Tag.all
				end
    end

    def set_post
      @post = @topic.posts.find(params[:id])
    end

		def post_params
			params.require(:post).permit(:title,:body,:image, tag_ids: [],tags_attributes: [:tag])
		end

		def check_rating_order(ratings)
			rating_hash = { 1 => 0 , 2 => 0 , 3 => 0, 4=> 0, 5=> 0 }
			ratings.group_by{ |t| t.rating }.each do |key,collection|
				rating_hash[key] = collection.size
			end
			rating_hash
    end

end
