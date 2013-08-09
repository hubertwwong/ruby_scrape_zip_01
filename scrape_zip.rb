require 'rubygems'
require 'capybara'
require 'capybara/dsl'

Capybara.run_server = false
Capybara.current_driver = :selenium
Capybara.app_host = 'http://www.google.com'

module ScrapeZip
  class Test
    include Capybara::DSL
    def test_google
      visit('/')
    end
  end
end

t = MyCapybaraTest::Test.new
t.test_google