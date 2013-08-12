require 'rubygems'
require 'capybara'
require 'capybara/dsl'
require 'headless'

require_relative 'scrape_util'
require_relative 'sql_util'

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
  
  
  
end