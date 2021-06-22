# With this configuration, now instead of doing
# 'FactoryBot.build :post' we can do 'build :post'
RSpec.configure do |config|
    config.include FactoryBot::Syntax::Methods
end