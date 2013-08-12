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
    
    # getting weird time out errors. wonder if this will help
    #Capybara.register_driver :selenium_with_long_timeout do |app|
    #  client = Selenium::WebDriver::Remote::Http::Default.new
    #  client.timeout = 120
    #  Capybara::Driver::Selenium.new(app, :browser => :firefox, :http_client => client)
    #end
    #Capybara.javascript_driver = :selenium_with_long_timeout
    
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
    
  end
  
  # saves a valid result to db.
  # using a string hash.
  def save_to_db(result_hash)
    #final_hash = result_hash
    #puts @table_name
    #puts result_hash.inspect
    
    @db.replace_one(@table_name, result_hash)
  end

  # retrieves the population of the city if its found in wikipedia
  # returns -1 if if cant find population
  def get_population(state_code, city_name)
    pop = -1
    headless = Headless.new(display: 100, destroy_at_exit: false)
    headless.start
    
    wiki_url = self.url_create(state_code, city_name)
    #visit 'http://www.google.com/'
    visit wiki_url
    puts 'gets here1111'
    
    # testing elements.
    # getting time out errors below
    # seems like page is broken
    # puts find(:xpath, '//table[@class="infobox geography vcard"]').inspect
    #puts page.has_text?('About Google').inspect
    #puts page.has_text?('Main page').inspect
    #puts page.has_text?('Population').inspect
    #click_link('Main page')
    
    pop_text_found = false
    if page.has_content?('Population')
      puts 'in pop'
      page.all(:xpath, '//table[@class="infobox geography vcard"]//tr').each do |row|
        puts row.text
        
        # want to find the population text before running  this.
        if pop_text_found
          puts 'found the pop....'
          puts row.text
          puts row.has_content?('td')
          pop = row.find('td').text
          
          # remove brackets on some of the populations with annotations.
          pop = pop.gsub(/[\[].+$/, '')
          break
          #row.find(",").text
        end
        
        # checks for the pop header. sets a flag.
        # the row after that contains the population
        if row.has_content?('Population')
          pop_text_found = true
        end
        
      end
    end
    puts 'pop ends'
    
    # clean up headless
    headless.destroy
    
    pop
    
    # see if you have a valid page.
    # this assumes the url_create method is working correctly
    # result = first(:xpath, '//div[@id="result-cities"]/p[@class="std-address"]')
    #error_strs = ['Wikipedia does not have an article with this exact name.']
    
    #if ScrapeUtil.has_content_or?(page, error_strs)
    #if page.has_content? 'Wikipedia does not have an article with this exact name.'
      #puts "empty page"
      #false
    #else
      #puts "gets here1"
      # checks to see if has the word population
      # chances are if it doesn't have the word, the page does not contain it.
      #city_strs = ['Population']
      #if ScrapeUtil.has_content_or?(page, city_strs)
        #puts "gets here"
        #within('//table[@class="infobox geography vcard"') do
          # there is a tr/th with the word population. this is probably
          # a good jumping off point.
          # the actual population is on the next row.
          #all('tr').each do |row|
          #  puts row
          #end
        #end
        
        #true
      #else
        #false
      #end
    #end
  end
  
  # UTIL FUNCTIONS
  ############################################################################

  # prepends the wikipedia url to the url_suffix_create method.
  # should give you a valid city url if it exist.
  # assumes its in english. 
  def url_create(state_code, city_name)
    'http://en.m.wikipedia.org/wiki/' + self.url_suffix_create(state_code, city_name)
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