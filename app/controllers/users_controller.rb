class UsersController < ApplicationController

 before_action :authenticate_user!
 before_action :correct_user, only: [:edit]


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
end
