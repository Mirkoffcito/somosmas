class Message < ApplicationRecord
  acts_as_paranoid

  belongs_to :user
  belongs_to :chat

  before_save :profanity

  private
  
  def generate_string(number)
    charset = ['&','%','$','#','*']
    Array.new(number) { charset.sample }.join
  end

  def profanity
    test = self.detail.split(/([\-,.¿?!¡ ])/)
    profanities = Profanity.all
    test.each_with_index do |pal, i|
      profanities.each do |str|
        if str.word.in? pal.downcase
          test[i] = generate_string(pal.length) # reemplaza la palabra con un string
          self.censored = true unless self.censored == true
        end
      end
    end
    self.detail = test.join # genera el nuevo string
  end
end
