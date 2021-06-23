# frozen_string_literal: true

FactoryBot.define do
  factory :admin_role, class: 'Role' do
    name { 'admin' }
    description { 'administrator' }
  end

  factory :client_role, class: 'Role' do
    name { 'client' }
    description { 'client' }
  end
  
end
