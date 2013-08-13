require 'rubygems'
require 'mechanize'

require_relative 'sql_util'
require_relative 'scrape_util'
require_relative 'state_util'
require_relative 'yaml_util'

class MechanizeWiki
  
  # instance variables for the db.
  attr_accessor :url, :user, :password, :db_name, :table_name, :web_url, :user_agent
  
  def initialize#(params = {})
    # reading a config file.
    @config_filename = 'config/wiki_progress.yml'
   
    # load the yaml file.
    @prefs = YamlUtil.read(@config_filename)
    
    # db credentials.
    #@url = params.fetch(:url)
    #@user = params.fetch(:user)
    #@password = params.fetch(:password)
    #@db_name= params.fetch(:db_name)
    #@table_name= params.fetch(:table_name)
    
    # yaml read test....
    @user = @prefs['db_user']
    @password = @prefs['db_password']
    @url = @prefs['db_url']
    @db_name = @prefs['db_name']
    @table_name = @prefs['db_table_name']
    @timeout = @prefs['timeout']
    
    # UA. wikipedia is picky on the UA.
    #@user_agent = "'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_4; en-us) AppleWebKit/533.17.8 (KHTML, like Gecko) Version/5.0.1 Safari/533.17.8' );"
    @user_agent = @prefs['user_agent']
    
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
  
  def run_yaml
    cities_all = @db.read_all_order_by(@table_name, 'ZIP')
    cur_pos = @prefs['cur_pos'].to_i
    # current position. pulled from yaml file.
    
    # go through each city.
    cities_all.each do |cur_city|
      # check if your at the offset.
      # that is specified at the config file before you start.
      if cur_city['ZIP'].to_i >= cur_pos.to_i
        puts 'on ' + cur_city['CITY'] + ', ' + cur_city['STATE'] + ' - ' + cur_city['ZIP'] 
        cur_pop = self.get_population(cur_city['STATE'], cur_city['CITY'])
        puts 'pop ' + cur_pop
      
        # check if the population is larger than zero
        if cur_pop.to_i > 0  
          cur_city_new_pop = cur_city
          cur_city_new_pop['POPULATION'] = cur_pop
          self.save_to_db(cur_city_new_pop)
          
          # update the position.
          @prefs.store('cur_pos', cur_city['ZIP'].to_i)
          YamlUtil.write(@config_filename.to_s, @prefs)
        end
      end
      
      # add a lag so you don't spam wikipdia
      sleep @timeout
    end
  end
  
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
        #city_geocard = p.search('//table[@class="infobox geography vcard"]//tr')
        city_geocard = p.search('//table//tr')
        # albany ny. has a weird class name. can't assume its consistent.
        
        # pop flag to spot the word population
        pop_flag = false
        
        # check if the card exist.
        if city_geocard.length > 0
          # cycle thru each row of the geo card on the left side
          city_geocard.each do |row|
            #puts "> " + row.text
            
            if pop_flag == true
              #puts 'aaaa'
              #puts row.text
              #puts 'aaaa'
              #puts row.search('td').text
              #puts 'aaaa'
              #puts row.search('th').text
              #puts row.text
              #puts 'zzzz'
              
              # clean population text.
              # stash result to return
              result = self.pop_clean(row.search('td').text)
              break
            end
            
            # population number starts after this marker..
            # there are some cases where the population is on the same row.
            # see Albany, NY page
            if row.text.include? 'Population'
              #puts ">>>>"  + row.text
              #puts row.search('td').text.inspect
              #puts ">>>>"
              
              # checks for a non td. albany has the pop on this line.
              # most other cities have it on the next line.
              unless row.search('td').text == ""
                result = self.pop_clean(row.search('td').text)
                break
              end
              
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
    
    puts "pop " + result.to_s
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
    state_name_full = StateUtil.abbv_to_state(state_code)
    
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
    final_url = @web_url + self.url_suffix_create(state_code, city_name)
    puts final_url
    final_url
  end

  # UTILITY methods
  ############################################################################

  # pop cleaner
  # a utility method to clean the population number that gets scraped
  # some has suffixes which might mean an annotation but is not included.
  #
  # changed this so it only takes comma seperated values.
  # populations seems to come only in this format.
  # 3,123,232 or 2,132
  def pop_clean(dirty_pop_text)
    pop = /^(?:\d{1,3}(?:[,]\d{3})*|\d+)/.match(dirty_pop_text).to_s
    pop = pop.gsub(',','')
    # remove the commas
    
    #pop = dirty_pop_text.gsub(/[ \[].+$/, '')
    #pop = pop.gsub(/[ ].+$/ , '')
    #pop = pop.gsub(/[\(].+$/ , '')
    pop
  end
  
  # saves a valid result to db.
  # assumes you used the hashing method in the funciton.
  def save_to_db(result_hash)
    #final_hash = result_hash
    # strip out commas in population.
    #final_hash["POPULATION"] = final_hash["POPULATION"].gsub(",", '')
    #puts "> saving"
    #puts final_hash.inspect
    
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