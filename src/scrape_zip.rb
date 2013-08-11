require 'rubygems'
require 'capybara'
require 'capybara/dsl'

require_relative 'scrape_util'


class ScrapeZip
  
  include Capybara::DSL
  Capybara.default_driver = :selenium
  #Capybara.app_host = 'http://www.google.com'

  
  # test to see if rspec test is working.
  def hello
    true
  end
  
  def initalize
    # this seems broken.
    @url = 'https://tools.usps.com/go/ZipLookupAction!input.action'
  end
  
  # runner.
  def run
    
  end
  
  # visit main usps url
  def visit_url
    visit 'https://tools.usps.com/go/ZipLookupAction!input.action'
    
    strs = ['Street Address']
    ScrapeUtil.has_content_and?(page, strs)
  end
  
  def click_zip_search_tab
    click_link("Cities by ZIP Code", exact: false)
    
    # string to check
    strs = ['Get a list of all the cities in a ZIP Code']
    ScrapeUtil.has_content_and?(page, strs)
  end
  
  # enter listed zip code.
  # checks if its a valid zip or not.
  # if its not, return false.
  # if its true, return a string with the city and state
  def enter_zip_and_search(code)
    fill_in 'tZip', :with => code
    click_button 'Find'
    
    # checks if it found a valid zip code.
    # 2 conditions to fail a search.
    #  1. if zip is in a valid format and no city is found.
    #  2. if zip is not in a valid format.
    # pages contains those strings.
    strs = ['Sorry', 'You did not enter a valid ZIP Code']
    if ScrapeUtil.has_content_or?(page, strs)
      false
    else
      # found a valid zip.
      # the first p tag contains the city.
      result = first(:xpath, '//div[@id="result-cities"]/p')
      #result.text
      self.city_state_as_hash(code, result.text)
    end  
  end
  
  # UTILITY FUNCTIONS
  ############################################################################
  
  # USPS websites returns the result as a string,
  # returns the whole thing as a hash so you can insert result into db. 
  # assumes city state is in this format 'LOS ANGELES CA'
  #
  # so if the zip is 90026 and the string is 'LOS ANGELES CA'
  # it should return {'city' => 'LOS ANGELES', 'state' => 'CA', 'zip_code' => 91770}
  def city_state_as_hash(zip_code, city_state_str)
    result_hash = Hash.new
    
    # need rstrip to remove extra spaces on the right side.
    result_hash['city'] = /(\w+\s)+/.match(city_state_str)[0].rstrip
    result_hash['state'] = /\w\w$/.match(city_state_str)[0]
    result_hash['zip_code'] = zip_code
    
    result_hash
  end
  
  # regex for city state.
  # state
  # \w\w$
  #
  # city
  # (\w+\s)+
  #
  # http://rubular.com/
end