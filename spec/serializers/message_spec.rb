require 'rails_helper'

describe MessageSerializer do
    let(:chat) { create(:chat) }
    let(:chatuser) { create(:chat_user, user_id: user.id, chat_id:chat.id) }

    context " when user settings are 'upcase' " do
        let(:user) { create(:user, settings:'upcase') }
        let(:message) { create(:message, user_id:user.id, chat_id:chat.id, detail:'minuscula') }
        it 'renders details in UPCASE' do
            expect(MessageSerializer.new(message).as_json[:detail]).to eq("MINUSCULA")
        end
    end

    context " when user settings are 'downcase' " do
        let(:user) { create(:user, settings:'downcase') }
        let(:message) { create(:message, user_id:user.id, chat_id:chat.id, detail:'MAYUSCULA') }
        it 'renders details in DOWNCASE' do
            expect(MessageSerializer.new(message).as_json[:detail]).to eq("mayuscula")
        end
    end

    context " when user settings are 'accentless' " do
        let(:user) { create(:user, settings:'accentless') }
        let(:message) { create(:message, user_id:user.id, chat_id:chat.id, detail:'ladró, calló, maulló') }
        it 'renders details without ACCENTS (tildes)' do
            expect(MessageSerializer.new(message).as_json[:detail]).to eq("ladro, callo, maullo")
        end
    end

    context " when user settings are 'none' " do
        let(:user) { create(:user) }
        let(:message) { create(:message, user_id:user.id, chat_id:chat.id, detail:'ladró, CALLO, Maullo') }
        it 'renders details without changes' do
            expect(MessageSerializer.new(message).as_json[:detail]).to eq("ladró, CALLO, Maullo")
        end
    end
end