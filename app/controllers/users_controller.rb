class UsersController < ApplicationController

 before_action :authenticate_user!, only: [:show]
 before_action :correct_user, only: [:edit]
 before_action :ensure_guest_user, only: [:edit]

 def new
   @user = User.new
 end

 def create
   @user = User.new(user_params)
   if @user.save
     redirect_to users_path
     flash[:notice]="Signed in successfully."
   else
     @users = User.all
     render:index
   end
 end

  def index
    @users = User.all
    @user = current_user
    @newbook = Book.new
  end

  def show
    @user = User.find(params[:id])
    #在ログインしているユーザーと、「チャットへ」を押されたユーザーの両方を
    #Entriesテーブルに記録する必要があるので、whereメソッドでそのユーザーを探す
    @currentUserEntry = Entry.where(user_id: current_user.id)
    @userEntry = Entry.where(user_id: @user.id)
    #現在ログインしているユーザーではないという条件をつけ、roomが作成されている場合とされていない場合に分岐させます
    unless @user.id == current_user.id
      @currentUserEntry.each do |cu|
        @userEntry.each do |u|
          #それぞれEntriesテーブル内にあるroom_idが共通しているユーザー同士に対して@roomId = cu.room_idという変数を指定する。
          if cu.room_id == user_id then
            #falseのとき（Roomを作成するとき）の条件を分岐するための記述
            @isRoom = true
            @roomId = cu.room_id
          end
        end
      end
      if @isRoom
      else
        @room = Room.new
        @entry = Entry.new
      end
    end

    @books = @user.books
    @newbook = Book.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user)
      flash[:notice]="You have updated user successfully."
    else
      render:edit
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :profile_image, :introduction)
  end

  def correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user.id)
    end
  end

  def ensure_guest_user
    @user = User.find(params[:id])
    if @user.name == "guestuser"
      redirect_to user_path(current_usr), notice: "ゲストユーザーはプロフィール編集画面へ遷移できません。"
    end
  end

end
