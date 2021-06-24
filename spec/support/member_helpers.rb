module Request
  module MemberHelpers
    
    def compare_member(response, member)
      expect(response[:member][:name]).to eq(member.name)
      expect(response[:member][:description]).to eq(member.description)
    end

    def create_member(attributes, token)
      post '/api/members',
        headers: { 'Authorization': token},
        params: { member: attributes }
    end
    
    def update_member(id, attributes, token)
      put "/api/members/#{id}",
        headers: { 'Authorization': token},
        params: { member: attributes }
    end

    def delete_member(id, token)
      delete "/api/members/#{id}",
        headers: { 'Authorization': token}
    end
    
    def check_keys(array)
      array.each do |element|
        expect(element).to have_key(:name)
        expect(element).to have_key(:description)
      end

  end

  end
end