class Contact < ApplicationRecord
  acts_as_paranoid
  validates :name, presence: true
  validates :email, presence: true
  validates :message, presence: true
end
