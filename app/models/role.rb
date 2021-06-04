class Role < ApplicationRecord
    has_many :users
    validates :name, presence: true, uniqueness: true

    enum name: [:admin, :client] # ' 0 ' is Admin User, ' 1 ' is Client

end
