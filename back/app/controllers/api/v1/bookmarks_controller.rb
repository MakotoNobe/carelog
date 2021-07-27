class Api::V1::BookmarksController < ApplicationController
  before_action :authenticate_api_v1_user!

  def index
    user = User.find_by(id: current_api_v1_user.id)
    bookmarks = Bookmark.page(params[:page]).per(10)
                .where("user_id=?",current_api_v1_user.id)
                .order("created_at DESC")
    render json: { 'bookmarks': bookmarks }
  end

  def create
    @office = Office.find(params[:office_id])
    bookmark = @office.bookmarks.new(user_id: current_api_v1_user.id)
    if bookmark.save
      render json: { 'bookmark': bookmark }
    else
      render json: { status: 'ERROR'}
    end
  end

  def destroy
    @office = Office.find(params[:office_id])
    bookmark = @office.bookmarks.find_by(user_id: current_api_v1_user.id)
    if bookmark.present?
      bookmark.destroy
      render json: { 'bookmark': bookmark }
    else
      render json: { status: 'ERROR'}
    end
  end

end
