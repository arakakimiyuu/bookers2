class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  #140 字まで送信可能にする
  validates :message, presence: true, length: { maximam: 140 }
end
