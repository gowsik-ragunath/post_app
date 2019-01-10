class PostsController < ApplicationController

	def index
		@post = Post.all
	end

	def new
		@post = Post.new
	end

	def create
		@post = Post.new(post_paramas)
		@post.save
		redirect_to(root_path)
	end

	private

	def post_paramas
		params.require(:post).permit(:title,:body)
	end

end
