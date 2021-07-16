class Chat < ApplicationRecord
  acts_as_paranoid

  belongs_to :user1, class_name: "User", foreign_key: "user1_id"
  belongs_to :user2, class_name: "User", foreign_key: "user2_id"

  has_many :messages, dependent: :destroy
  has_many :users, through: :messages

  validates_uniqueness_of :user1_id, scope: :user2_id

  scope :between, -> (user1_id, user2_id) do
    where("(chat.user_id = ? AND chat.user2_id = ?) OR (chat.user2_id = ? AND chat.user1_id = ?)", user1_id, user2_id, user1_id, user2_id)
  end

end