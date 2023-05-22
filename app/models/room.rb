class Room < ApplicationRecord
  belongs_to :user
  #DM機能
  has_many :messages, dependent: :destroy
  has_many :entries, dependent: :destroy
end
