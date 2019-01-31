class RatingsController < ApplicationController
  before_action :set_post, only: [:index, :show, :edit, :update, :destroy, :new, :create ]
  before_action :set_rating, only: [:show, :edit, :update, :destroy ]
  # GET /ratings
  # GET /ratings.json
  def index
    @ratings = @post.ratings
  end

  # GET /ratings/new
  def new
    @rating = @post.ratings.new
  end

  # POST /ratings
  # POST /ratings.json
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

  # DELETE /ratings/1
  # DELETE /ratings/1.json
  def destroy
    @rating.destroy
    respond_to do |format|
      format.html { redirect_to topic_post_url, notice: 'Rating was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.

    def set_post
      @topic = Topic.find(params[:topic_id])
      @post = @topic.posts.find(params[:post_id])
    end

    def set_rating
      @rating = Rating.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rating_params
      params.permit(:rating)
    end
end
