class Role < ApplicationRecord
    validates :name, presence: true, blank: false, uniqueness: true
end
