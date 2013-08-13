require 'rubygems'
require 'capybara'
require 'capybara/dsl'

require_relative 'scrape_util'
require_relative 'sql_util'

class ScrapeZip
  
  # init in class instead of global space.
  include Capybara::DSL
  Capybara.default_driver = :selenium

  # instance variables.
  attr_accessor :web_url, :url, :user, :password, :db_name, :table_name

  # test to see if rspec test is working.
  def hello
    true
  end
  
  def initialize(params = {})
    @web_url = params.fetch(:web_url)
    
    # db credentials.
    @url = params.fetch(:url)
    @user = params.fetch(:user)
    @password = params.fetch(:password)
    @db_name= params.fetch(:db_name)
    @table_name= params.fetch(:table_name)
    
    # init db helper
    @db = SqlUtil.new(:url => @url, 
                      :user=> @user, 
                      :password => @password, 
                      :db_name => @db_name)
  end
  
  # runner.
  # call this to run the scraper.
  def run
    
  end
  
  # visit main usps url
  def visit_url
    visit @web_url #'https://tools.usps.com/go/ZipLookupAction!input.action'
    
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
      hash_result = self.city_state_as_hash(code, result.text)
      
      # save to db.
      self.save_to_db(hash_result)
      
      hash_result
    end
  end
  
  
  # UTILITY FUNCTIONS
  ############################################################################
  
  # saves a valid result to db.
  # assumes you used the hashing method in the funciton.
  def save_to_db(result_hash)
    puts @table_name
    puts result_hash.inspect
    @db.replace_one(@table_name, result_hash)
  end
  
  # USPS websites returns the result as a string,
  # returns the whole thing as a hash so you can insert result into db. 
  # assumes city state is in this format 'LOS ANGELES CA'
  #
  # so if the zip is 90026 and the string is 'LOS ANGELES CA'
  # it should return {'city' => 'LOS ANGELES', 'state' => 'CA', 'zip_code' => 91770}
  def city_state_as_hash(zip_code, city_state_str)
    result_hash = Hash.new
    
    # need rstrip to remove extra spaces on the right side.
    result_hash['CITY'] = /(\w+\s)+/.match(city_state_str)[0].rstrip
    result_hash['STATE'] = /\w\w$/.match(city_state_str)[0]
    result_hash['ZIP'] = zip_code
    
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