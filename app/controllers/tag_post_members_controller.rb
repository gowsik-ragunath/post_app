class TagPostMembersController < ApplicationController
  before_action :set_tag_post_member, only: [:show, :edit, :update, :destroy]

  # GET /tag_post_members
  # GET /tag_post_members.json
  def index
    @tag_post_members = TagPostMember.all
  end

  # GET /tag_post_members/1
  # GET /tag_post_members/1.json
  def show
  end

  # GET /tag_post_members/new
  def new
    @tag_post_member = TagPostMember.new
  end

  # GET /tag_post_members/1/edit
  def edit
  end

  # POST /tag_post_members
  # POST /tag_post_members.json
  def create
    @tag_post_member = TagPostMember.new(tag_post_member_params)

    respond_to do |format|
      if @tag_post_member.save
        format.html { redirect_to @tag_post_member, notice: 'Tag post member was successfully created.' }
        format.json { render :show, status: :created, location: @tag_post_member }
      else
        format.html { render :new }
        format.json { render json: @tag_post_member.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tag_post_members/1
  # PATCH/PUT /tag_post_members/1.json
  def update
    respond_to do |format|
      if @tag_post_member.update(tag_post_member_params)
        format.html { redirect_to @tag_post_member, notice: 'Tag post member was successfully updated.' }
        format.json { render :show, status: :ok, location: @tag_post_member }
      else
        format.html { render :edit }
        format.json { render json: @tag_post_member.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tag_post_members/1
  # DELETE /tag_post_members/1.json
  def destroy
    @tag_post_member.destroy
    respond_to do |format|
      format.html { redirect_to tag_post_members_url, notice: 'Tag post member was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tag_post_member
      @tag_post_member = TagPostMember.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tag_post_member_params
      params.require(:tag_post_member).permit(:tag_id, :post_id)
    end
end
