class GroupUser < ApplicationRecord
  belongs_to :user
  belongs_to :g
end
