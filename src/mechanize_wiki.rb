require 'rubygems'
require 'mechanize'

require_relative 'sql_util'
require_relative 'scrape_util'
require_relative 'state_util'

class MechanizeWiki
  
  # instance variables for the db.
  attr_accessor :url, :user, :password, :db_name, :table_name, :web_url, :user_agent
  
  def initialize(params = {})
    # db credentials.
    @url = params.fetch(:url)
    @user = params.fetch(:user)
    @password = params.fetch(:password)
    @db_name= params.fetch(:db_name)
    @table_name= params.fetch(:table_name)
    
    # UA. wikipedia is picky on the UA.
    @user_agent = "'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_4; en-us) AppleWebKit/533.17.8 (KHTML, like Gecko) Version/5.0.1 Safari/533.17.8' );"
    
    # using wikipedia mobile url.
    # seems to be faster.
    @web_url = 'http://en.m.wikipedia.org/wiki/'
    
    # init db helper
    @db = SqlUtil.new(:url => @url, 
                      :user=> @user, 
                      :password => @password, 
                      :db_name => @db_name)
  end

  # Main methods
  ############################################################################
  
  # run. this will try to fetch the population of every city in Murica
  # basically goes to the db. grabs a list of population 0
  # and hits wikipeida to find a populattion.
  def run(timeout)
    cities_no_pop = @db.read_all_one_param_order_by(@table_name, 'population', '0', 'CITY')
    
    # go through each city.
    cities_no_pop.each do |cur_city|
      puts 'on ' + cur_city['CITY'] + ', ' + cur_city['STATE']
      cur_pop = self.get_population(cur_city['STATE'], cur_city['CITY'])
      puts 'pop ' + cur_pop
      
      if cur_pop.to_i > 0
        cur_city_new_pop = cur_city
        cur_city_new_pop['POPULATION'] = cur_pop
        self.save_to_db(cur_city_new_pop)
      end
      
      # add a lag so you don't spam wikipdia
      sleep timeout
    end
  end
  
  # goes to wikipedia to grab the population if the city exist.
  def get_population(state_code, city_name)
    puts 'finding pop of ' + city_name + ', ' + state_code
    
    # stores result
    # return '0' instead of nil so it doesn't break stuff
    result = '0'
    
    # load the user agent.
    a = Mechanize.new { |agent|
      agent.user_agent = @user_agent
    }
    
    # convert url to the zip
    actual_url = self.url_create(state_code, city_name)
    
    begin
      # go to page and fetch the population.
      a.get(actual_url) do |p|
        # check if city card to the right is there.
        city_geocard = p.search('//table[@class="infobox geography vcard"]//tr')
        
        # pop flag to spot the word population
        pop_flag = false
        
        # check if the card exist.
        if city_geocard.length > 0
          # cycle thru each row of the geo card on the left side
          city_geocard.each do |row|
            if pop_flag == true
              #puts 'aaaa'
              #puts row.text
              #puts 'aaaa'
              puts row.search('td').text
              #puts 'aaaa'
              #puts row.search('th').text
              #puts row.text
              #puts 'zzzz'
              
              # clean population text.
              # stash result to return
              result = self.pop_clean(row.search('td').text)
              break
            end
            
            if row.text.include? 'Population'
              puts ">>>>"  + row.text
              pop_flag = true
            end
            #if pop_text_flag == true
            #  break
            #end
          end
        end
      end
    rescue Exception => e
      # want to ignore 404 errors
      puts e
    end
    
    result
  end

  # URL methods
  ############################################################################
  
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

  # prepends the wikipedia url to the url_suffix_create method.
  # should give you a valid city url if it exist.
  # assumes its in english. 
  def url_create(state_code, city_name)
    @web_url + self.url_suffix_create(state_code, city_name)
  end

  # UTILITY methods
  ############################################################################

  # pop cleaner
  # a utility method to clean the population number that gets scraped
  # some has suffixes which might mean an annotation but is not included.
  def pop_clean(dirty_pop_text)
    pop = dirty_pop_text.gsub(/[ \[].+$/, '')
    pop = pop.gsub(/[ ].+$/ , '')
    pop = pop.gsub(/[\(].+$/ , '')
    pop
  end
  
  # saves a valid result to db.
  # assumes you used the hashing method in the funciton.
  def save_to_db(result_hash)
    #final_hash = result_hash
    #puts @table_name
    puts "saving"
    puts result_hash.inspect
    
    # pad the zip.
    #padded_num = sprintf '%05d', final_hash['ZIP']
    #final_hash['ZIP'] = padded_num
    
    @db.replace_one(@table_name, result_hash)
  end

  # just used to test if rspec file read this correct.
  # can ignore.
  def hello
    true
  end

end