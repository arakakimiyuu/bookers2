class RoomsController < ApplicationController
  before_action :authenticate_user!
  #Room以外にその子モデルのEntryもcreateさせなければいけないので、Entriesテーブルに入る相互フォロー同士のユーザーを保存させるための記述
  def create
    @room = Room.create
    #現在ログインしているユーザー
    @entry1 = Entry.create(room_id: @room.id, user_id: current_user.id)
    #フォローされている側の情報をEntriesテーブルに保存するための記述
    @entry2 = Entry.create(params.require(:entry).permit(:user_id, :room_id).merge(room_id: @room.id))
    redirect_to "/rooms/#{@room.id}"
  end

  def show
    @room = Room.find(params[:id])
    if Entry.where(user_id: current_user.id, room_id: @room.id).present?
      @messages = @room.messages
      @message = Message.new
      @entries = @room.entries
    else
      redirect_back(fallback_location: root_path)
    end
  end
end
