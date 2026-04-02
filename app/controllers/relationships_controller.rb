class RelationshipsController < ApplicationController
  before_action :authenticate

  def create
    @user = User.find(relationship_params[:followed_id])
    current_user.follow!(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  private

  def relationship_params
    params.require(:relationship).permit(:followed_id)
  end
end
