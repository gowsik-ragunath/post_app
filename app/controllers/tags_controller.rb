class TagsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tag, only: [:show, :edit, :update, :destroy]

  def index
    @tags = Tag.all
  end

  def show
  end

  def new
    @tag = Tag.new
  end

  def edit
  end

  def create
    @tag = Tag.new(tag_params)
    respond_to do |format|
      if @tag.save
        flash[:success] = 'Tag was successfully created.'
        format.html { redirect_to tags_path }
        format.json { render :show, status: :created, location: @tag }
      else
        format.html { render :new }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @tag.update(tag_params)
        flash[:warning] = 'Tag was successfully updated.'
        format.html { redirect_to @tag}
        format.json { render :show, status: :ok, location: @tag }
      else
        format.html { render :edit }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @tag.destroy
        flash[:destroy] = 'Tag was successfully destroyed.'
        format.html { redirect_to topic_posts_path }
        format.json { head :no_content }
      else
        flash[:destroy] = 'Tag doesn\'t exist.'
        format.html { redirect_to topic_posts_path }
        format.json { head :not_found }
      end
    end
  end

  private
  def set_tag
    @tag = Tag.find(params[:id])
  end

  def tag_params
    params.require(:tag).permit(:tag)
  end
end
