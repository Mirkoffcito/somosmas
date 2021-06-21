# With this configuration, now instead of doing
# 'FactoryBot.build :post' we can do 'build :post'
require 'factory_bot'
RSpec.configure do |config|
    config.include FactoryBot::Syntax::Methods
end