require 'rails_helper'

RSpec.describe Message, type: :model do
  describe 'Creating message' do
    let(:chat) { create(:chat) }
    let(:user1) { create(:chat_user, :with_admin_user, chat_id:chat.id) }
    let(:user2) { create(:chat_user, :with_admin_user, chat_id:chat.id) }
    let(:profanities) { ['boludo', 'tonto', 'bobo', 'tarado'] }
    context 'message contains profanities' do
      before do
        profanities.each do |prof|
          create(:profanity, word:prof) # Saves the profanities to the database for later use
        end
      end
      let(:message) { create(:message, user_id:user1.id, chat_id:chat.id, detail:"No seas tonto! Boludo") }
      it 'replaces profanities with random symbols' do
        # The message.detail saved won't be the one sent by the user, because it has been censored.
        expect(message.detail).not_to eq("No seas tonto! Boludo")
        # it will check if any of profanities words are included in the created message
        # it will return false, because the message has been censored 
        expect(profanities.any? { |word| message.detail.include?(word) } ).to eq(false)
      end
      it "changes 'censored' flag from false to true" do
        expect(message.censored).to eq(true)
      end
    end

    context 'message does not contain profanities' do
      let(:message) { create(:message, user_id:user1.id, chat_id:chat.id, detail:"Hola Jose! Como estas?") }
      it 'does not censor the message' do
        # The message.detail saved to the database will be the same the user sent
        expect(message.detail).to eq("Hola Jose! Como estas?")
        # it will check if any of profanities words are included in the created message
        # it will return false, because the message has been censored 
        expect(profanities.any? { |word| message.detail.include?(word) } ).to eq(false)
      end
      it 'does not change censored flag from false to true' do
        expect(message.censored).to eq(false)
      end
    end
  end
end
