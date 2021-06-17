class Comment < ApplicationRecord
  acts_as_paranoid
  belongs_to :user
  belongs_to :new

  validates :new_id, presence: true

  default_scope {order(created_at: :asc)}

end
