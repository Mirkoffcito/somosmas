class Chat < ApplicationRecord
    acts_as_paranoid
    has_many :chat_users
    has_many :users, through: :chat_users

    has_many :messages, dependent: :destroy

    validates_length_of :chat_users, maximum: 2
end
