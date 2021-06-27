module Request
  module MemberHelpers

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