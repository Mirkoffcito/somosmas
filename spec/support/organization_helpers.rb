# frozen_string_literal: true

module Request
  module OrganizationHelpers
    def compare_organization(response, organization)
      expect(response[:organization][:name]).to eq(organization.name)
      expect(response[:organization][:email]).to eq(organization.email)
      expect(response[:organization][:welcome_text]).to eq(organization.welcome_text)
    end

    def update_organization(attributes, token)
      patch '/api/organization/public',
            headers: { 'Authorization': token },
            params: { organization: attributes }
    end

    def check_keys(_response)
      response do |element|
        expect(element).to have_key(:name)
        expect(element).to have_key(:email)
        expect(element).to have_key(:welcome_text)
      end
    end
  end
end
