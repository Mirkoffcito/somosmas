FactoryBot.define do
  factory :admin, class: Role do
    name { 'admin' }
    description { 'administrador' }
  end
end

FactoryBot.define do
  factory :client, class: Role do
    name { 'client' }
    description { 'cliente' }
  end
end