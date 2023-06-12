class Group < ApplicationRecord

  has_many :group_users, dependent: :destroy
  belongs_to :owner, class_name: 'User'
  #Group モデルが GroupUser モデルを通じて User モデルと関連していることを表す
  has_many :users, through: :group_users, source: :user

  validates :name, presence: :true
  validates :introduction, presence: :true
  has_one_attached :group_image

  def is_owned_by?(user)
    owner.id == user.id
  end
  #与えられたuserがグループのメンバーであるかどうかを判定
  def includesUser?(user)
   group_users.exists?(user_id: user.id)
  end
end
