require 'rubygems'
require 'capybara'
require 'capybara/dsl'
require 'headless'

require_relative 'scrape_util'
require_relative 'sql_util'

class ScrapeZip2
  # init in class instead of global space.
  include Capybara::DSL
  
  # instance variables.
  attr_accessor :web_url, :url, :user, :password, :db_name, :table_name

  # test to see if rspec test is working.
  def hello
    true
  end
  
  def initialize(params = {})
    #Capybara.default_driver = :selenium
    #Capybara.default_driver = :rack_test
    Capybara.javascript_driver = :webkit
    
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
  
  # MAIN FUNCTIONS
  ############################################################################
  
  def run
    headless = Headless.new(display: 100, destroy_at_exit: false)
    headless.start
    
    # go through every zip code and search.
    99999.times do |i|
      padded_num = sprintf '%05d', (i + 2458)
      self.enter_zip_and_search(padded_num.to_s)
    end
    
    headless.destroy
  end
  
  def enter_zip_and_search(code)
    # url. swap out the zip for the one you are looking.
    final_url = self.replace_zip_in_url(code)
    visit final_url
    
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
      result = first(:xpath, '//div[@id="result-cities"]/p[@class="std-address"]')
      
      # stores the result as a hash.
      hash_result = self.city_state_as_hash(code, result.text)
      
      # save to db.
      self.save_to_db(hash_result)
      
      hash_result
    end
  end
  
  # UTILITY FUNCTIONS
  ############################################################################
  
  # swaps out the zip code in the url for the correct one.
  # assumes 00000 is the inital zip in the url
  def replace_zip_in_url(code)
    @web_url.gsub(/00000/, code.to_s)
  end
  
  # saves a valid result to db.
  # assumes you used the hashing method in the funciton.
  def save_to_db(result_hash)
    #final_hash = result_hash
    puts @table_name
    puts result_hash.inspect
    
    # pad the zip.
    #padded_num = sprintf '%05d', final_hash['ZIP']
    #final_hash['ZIP'] = padded_num
    
    @db.replace_one(@table_name, result_hash)
  end
  
  # USPS websites returns the result as a string,
  # returns the whole thing as a hash so you can insert result into db. 
  # assumes city state is in this format 'LOS ANGELES CA'
  #
  # so if the zip is 90026 and the string is 'LOS ANGELES CA'
  # it should return {'city' => 'LOS ANGELES', 'state' => 'CA', 'zip_code' => 91770}
  def city_state_as_hash(zip_code, city_state_str)
    puts zip_code
    puts city_state_str
    city = /(\w+\s)+/.match(city_state_str)[0].rstrip
    puts city
    state = /\w\w$/.match(city_state_str)[0]
    puts state
    puts zip_code
    puts 'aaaa'
    
    result_hash = Hash.new
    
    # need rstrip to remove extra spaces on the right side.
    result_hash['CITY'] = /(\w+\s)+/.match(city_state_str)[0].rstrip
    result_hash['STATE'] = /\w\w$/.match(city_state_str)[0]
    result_hash['ZIP'] = zip_code
    
    result_hash
  end
  
end