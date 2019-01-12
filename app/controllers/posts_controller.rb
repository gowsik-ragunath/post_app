class PostsController < ApplicationController

	def index
		@post = Post.where("topic_id=?",params[:topic_id])
	end

	def new
		@post = Post.new
	end

	def create
		@post = Post.new(post_paramas)
		@post.save
		redirect_to(topic_posts_path)
	end

	def show
		@post = Post.find(params[:id])
	end

	def destroy
		@post = Post.find(params[:id])
		@post.destroy
		puts "!!!!!!!!!!!!!!!!!!!!!!!!"
		redirect_to(topic_posts_path)
	end

	def edit
		@post = Post.find(params[:id])
	end

	def update
		@post = Post.find(params[:id])
		if @post.update_attributes(post_paramas)
			redirect_to(topic_posts_path)
		else
			@post = Post.find(params[:id])
			render action: :edit
		end	
	end

	private

	def post_paramas
		params.require(:post).permit(:title,:body,:topic_id)
	end



end
