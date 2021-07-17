class Profanity < ApplicationRecord

    before_save { self.word.downcase! }
end
