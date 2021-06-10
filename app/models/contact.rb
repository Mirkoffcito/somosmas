# frozen_string_literal: true

class Contact < ApplicationRecord
  acts_as_paranoid
  validates :name, :email, :message, presence: true
end
