class Book < ApplicationRecord

 belongs_to :user
 has_many :favorites, dependent: :destroy
 #favoritesモデルを介してuserモデルのデータを持ってくる記述
 has_many :favorited_users, through: :favorites, source: :user
 has_many :book_comments, dependent: :destroy
 #閲覧数の表示
 has_many :view_counts, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true
  validates :body, length: { maximum: 200 }

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def self.looks(search, word)
    if search == "perfect_match"
      @books = Book.where("title LIKE?","#{word}")
    elsif search == "forward_match"
      @books = Book.where("title LIKE?","#{word}%")
    elsif search == "backward_match"
      @books = Book.where("title LIKE?","%#{word}")
    elsif search == "partial_match"
      @books = Book.where("title LIKE?","%#{word}%")
    else
      @books = Book.all
    end
  end
  #本の投稿数 scope :スコープの名前, -> { 条件式 }
  scope :created_today, -> { where(created_at: Time.zone.now.all_day) } # 今日
  scope :created_yesterday, -> { where(created_at: 1.day.ago.all_day) } # 前日

end
