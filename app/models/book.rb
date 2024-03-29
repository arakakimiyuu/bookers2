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
  validates :categry, presence: true

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
  scope :created_this_week, -> { where(created_at: 6.day.ago.beginning_of_day..Time.zone.now.end_of_day) } #今週
  scope :created_last_week, -> { where(created_at: 2.week.ago.beginning_of_day..1.week.ago.end_of_day)} #先週
  scope :created_2days, -> { where(created_at: 2.days.ago.all_day) } #2日前
  scope :created_3days, -> { where(created_at: 3.days.ago.all_day) } #3日前
  scope :created_4days, -> { where(created_at: 4.days.ago.all_day) } #4日前
  scope :created_5days, -> { where(created_at: 5.days.ago.all_day) } #5日前
  scope :created_6days, -> { where(created_at: 6.days.ago.all_day) } #6日前

  #sort機能
  scope :latest, -> {order(created_at: :desc)} #最新順
  scope :old, -> {order(created_at: :asc)} #古い順
  scope :star_count, -> {order(star: :desc)} #評価順

end
