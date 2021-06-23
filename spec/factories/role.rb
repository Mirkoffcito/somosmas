FactoryBot.define do
  factory :admin_role, class: 'Role' do
    name { 'admin' }
    description { 'administrador' }
  end

  factory :client_role, class: 'Role' do
    name { 'client' }
    description { 'cliente' }
  end

end