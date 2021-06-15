class AddSocialMediaLinksToOrganizations < ActiveRecord::Migration[6.0]
  def change
    add_column :organizations, :facebook_url, :string
    add_column :organizations, :instagram_url, :string
    add_column :organizations, :linkedin_url, :string
  end
end