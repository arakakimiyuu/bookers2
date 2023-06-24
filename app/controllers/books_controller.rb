class BooksController < ApplicationController

  before_action :authenticate_user!
  before_action :correct_user, only: [:edit]

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    @user = current_user
    if @book.save
     redirect_to book_path(@book)
     flash[:notice]="You have created book successfully."
    else
      @books = Book.all
      render:index
    end
  end

  def index
     @book = Book.new
     @books = Book.all
     @user = current_user
     #Time.current はconfig/application.rbに設定してあるタイムゾーンを元に現在日時を取得
     #at_end_of_day は1日の終わりを23:59に設定
     to = Time.current.at_end_of_day
     #at_beginning_of_day　は1日の始まりの時刻を0:00に設定
     from = (to - 6.day).at_beginning_of_day
     #ユーザーの情報がfavorited_usersに格納されて、includesの引数に入れ事前にユーザーのデータを取ってくる
     @books = Book.includes(:favorited_users).
     #ブロック変数 |x| を定義しないと、2よりも10,11の方が小さいと判定されるためこのように対処する
      sort_by {|x|
        x.favorited_users.includes(:favorites).where(created_at: from...to).size
      #reverseをつけることで昇順、降順を入れ替えることができる
      }.reverse
     @book = Book.new
     #sort機能
     if params[:latest]
       @books = Book.latest
     elsif params[:old]
       @books = Book.old
     elsif params[:star_count]
       @books = Book.star_count
     else
       @books = Book.all
     end
  end

  def show
    @book = Book.find(params[:id])
    @newcomment = BookComment.new
    @newbook = Book.new
    @user = @book.user
    @book_detail = Book.find(params[:id])
    unless ViewCount.find_by(user_id: current_user.id, book_id: @book_detail.id)
      current_user.view_counts.create(book_id: @book_detail.id)
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book.id)
      flash[:notice]="You have updated book successfully."
    else
      render:edit
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private
  def book_params
    params.require(:book).permit(:title, :body, :profile_image, :star, :category)
  end

  def correct_user
    @book = Book.find(params[:id])
    @user = @book.user
    redirect_to(books_path) unless @user == current_user
  end

end
