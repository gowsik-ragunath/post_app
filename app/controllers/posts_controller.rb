class PostsController < ApplicationController

	def index
		@post = Post.includes(:topic).where(topic_id: params[:topic_id]).paginate(page: params[:page], per_page: 10)
	end

	def new
		@post = Post.new
		@topic = Topic.all
		@tag = Tag.all
	end

	def create
		@post = Post.new(post_paramas)
		@post.save
		redirect_to(topic_posts_path)
	end

	def show
		@post = Post.find(params[:id])
		@comments = Comment.where(post_id: params[:id])
		@comment = Comment.new
		@tag_relation = TagPostMember.where(post_id: params[:id])
		@tags = []
		@tag_relation.each do |p|
			@var = Tag.find_by(id: p.tag_id)
			puts p.tag_id
			@tags.push(@var)
		end
	end

	def destroy
		@post = Post.find(params[:id])
		@post.destroy
		redirect_to(topic_posts_path)
	end

	def edit
		@post = Post.find(params[:id])
		@tag = Tag.all
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
		params.require(:post).permit(:title,:body,:topic_id, tag_ids: [])
	end



end
