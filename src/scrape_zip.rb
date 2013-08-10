require 'rubygems'
require 'capybara'
require 'capybara/dsl'


class ScrapeZip
  
  include Capybara::DSL
  Capybara.default_driver = :selenium
  #Capybara.app_host = 'http://www.google.com'

  
  # test to see if rspec test is working.
  def hello
    true
  end
  
  def initalize
    @url = 'https://tools.usps.com/go/ZipLookupAction!input.action'
  end
  
  # runner.
  def run
    
  end
  
  def visit_url
    visit @url
    page.has_content? 'Street Address'
  end
end