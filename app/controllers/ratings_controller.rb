class RatingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_topic, only: [:index, :show, :edit, :update, :destroy, :new, :create ]
  before_action :set_post, only: [:index, :show, :edit, :update, :destroy, :new, :create ]
  before_action :set_rating, only: [:show, :edit, :update, :destroy ]

  def index
    @ratings = @post.ratings
  end

  def new
    @rating = @post.ratings.new
  end

  def create
    @rating = @post.ratings.new(rating_params)
    respond_to do |format|
      if @rating.save
        format.html { redirect_to topic_post_path(params[:topic_id],params[:post_id]), notice: 'Rating was successfully created.' }
        format.json { render :show, status: :created, location: @rating }
      else
        format.html { render :new }
        format.json { render json: @rating.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @rating.destroy
    respond_to do |format|
      format.html { redirect_to topic_post_url, notice: 'Rating was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  def set_topic
    @topic = Topic.find(params[:topic_id])
  end

  def set_post
    @post = @topic.posts.find(params[:post_id])
  end

  def set_rating
    @rating = Rating.find(params[:id])
  end

  def rating_params
    params.permit(:rating)
  end
end
