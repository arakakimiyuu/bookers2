class Book < ApplicationRecord

  has_one_attached :image
  belong_to :user
end
