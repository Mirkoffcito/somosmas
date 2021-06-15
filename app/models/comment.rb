class Comment < ApplicationRecord
  acts_as_paranoid
  belongs_to :user
  belongs_to :new

  validates :user_id, presence: true
  validates :new_id, presence: true
end
