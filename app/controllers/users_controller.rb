class UsersController < ApplicationController

 def new
   @user = User.new
 end

 def create
   @user = User.new(user_params)
   @user.save
   redirect_to users_path
   flash[:notice]="Welcome! You have signed up successfully."
 end

  def index
    @users = User.all
    @user = current_user
  end

  def show
    @user = User.find(params[:id])
    @books = @user.books
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to users_path
      flash[:notice]="You have updated user successfully."
    else
      render:edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :profile_image, :introduction)
  end
end
