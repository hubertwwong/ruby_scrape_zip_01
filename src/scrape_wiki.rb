require 'rubygems'
require 'capybara'
require 'capybara/dsl'
require 'headless'

require_relative 'scrape_util'
require_relative 'sql_util'
require_relative 'state_util'

class ScrapeWiki
  # init in class instead of global space.
  include Capybara::DSL
  
  # instance variables.
  attr_accessor :url, :user, :password, :db_name, :table_name

  # test to see if rspec test is working.
  def hello
    true
  end
  
  def initialize(params = {})
    #Capybara.default_driver = :selenium
    #Capybara.default_driver = :rack_test
    #Capybara.javascript_driver = :webkit
    
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
    #headless = Headless.new(display: 100, destroy_at_exit: false)
    #headless.start
    
    # go through every zip code and search.
    #99999.times do |i|
    #  padded_num = sprintf '%05d', (i + 2458)
    #  self.enter_zip_and_search(padded_num.to_s)
    #end
    
    #headless.destroy
  end
  
  # saves a valid result to db.
  # using a string hash.
  def save_to_db(result_hash)
    #final_hash = result_hash
    #puts @table_name
    #puts result_hash.inspect
    
    @db.replace_one(@table_name, result_hash)
  end

  
  # UTIL FUNCTIONS
  ############################################################################

  # prepends the wikipedia url to the url_suffix_create method.
  # should give you a valid city url if it exist.
  # assumes its in english. 
  def url_create(state_code, city_name)
    'http://en.wikipedia.org/wiki/' + self.url_suffix_create(state_code, city_name)
  end
  
  # create the stuffix for city and sttate.
  # wiki cities are done in this format
  #
  # "Los_Angeles,_California"
  #
  # basically spaces are converted to underscores
  # states are spelled out.
  # caps for first letter of each word.
  # there is an additional underscrore that prefix the state.
  def url_suffix_create(state_code, city_name)
    # fetch state.
    state_name_full = StateUtil.abbv_to_state state_code
    
    # transform the state name.
    # there might be an issue with caps of non proper nouns.
    # names are in this format
    # _District_Of_Columbia
    # first letter is in caps and underscore in front of every word.
    state_name_full = state_name_full.split.map(&:capitalize).join(' ')
    state_name_full = state_name_full.gsub(/ /, '_')
    state_name_full = "_" + state_name_full
    
    # transform the city name.
    # Los_Angeles
    # caps for each word and underscore instead of space
    city_name_full = city_name.split.map(&:capitalize).join(' ')
    city_name_full = city_name_full.gsub(/ /, '_')
    
    # final url suffix
    city_name_full + "," + state_name_full
  end
  
end