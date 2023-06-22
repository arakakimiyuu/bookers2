class TagsearchesController < ApplicationController
  def seach
    @model = Book  #search機能とは関係なし
    @word = params[:content]
    @books = Book.where("category LIKE?", "%#{@word}%")
    render "tagreaches/tagseach"
  end
end
