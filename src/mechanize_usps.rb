require 'rubygems'
require 'mechanize'

require_relative 'sql_util'
require_relative 'yaml_util'

class MechanizeUsps
  
  # instance variables for the db.
  attr_accessor :url, :user, :password, :db_name, :table_name, :web_url, :user_agent
  
  def initialize(params = {})
    # reading a config file.
    @config_filename = 'config/usps_progress.yml'
   
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
    
    # UA. wikipedia is picky on the UA.
    #@user_agent = "'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_4; en-us) AppleWebKit/533.17.8 (KHTML, like Gecko) Version/5.0.1 Safari/533.17.8' );"
    @user_agent = @prefs['user_agent']
    
    # starting usps url.
    # basically, you just need to change the zip code.
    @web_url = 'https://tools.usps.com/go/ZipLookupResultsAction!input.action?resultMode=2&companyName=&address1=&address2=&city=&state=Select&urbanCode=&postalCode=00000&zip='

     
    # init db helper
    @db = SqlUtil.new(:url => @url, 
                      :user=> @user, 
                      :password => @password, 
                      :db_name => @db_name)
  end

  # MAIN
  ############################################################################
  
  # loops through the main method and stores the result into the db.
  # using the yaml file instead.
  def run_yaml
    #puts @prefs.inspect
    cur_offset = @prefs['cur_pos']
    cur_timeout = @prefs['timeout']
    
    cur_offset.upto(99999) do |i|
      puts 'on ' + i.to_s
      self.find_and_save_zip(i)
      
      # update position.
      @prefs.store('cur_pos', i)
      #puts @prefs.inspect
      #puts @config_filename.to_s
      YamlUtil.write(@config_filename.to_s, @prefs)
      
      # sleep
      sleep cur_timeout
    end
  end
  
  # loops through the main method and stores the result into the db.
  # has an offset argument that can be used to scrape in parallel.
  def run(offset, timeout)
    puts 'offset ' + offset.to_s
    offset.upto(99999) do |i|
      puts 'on ' + i.to_s
      self.find_and_save_zip(i)
      
      # update position.
      #@prefs.store("cur_pos", i)
      #puts @prefs.inspect
      #puts @config_filename.to_s
      #YamlUtil.write(@config_filename.to_s, @prefs)
      
      # sleep
      sleep timeout
    end
  end
  
  # find and save zip
  def find_and_save_zip(zip)
    # find url
    result = self.find_city_and_state(zip)
    
    # save result if its not nil
    unless result.nil?
      self.save_to_db(result)
      true
    else
      false
    end
  end
  
  # finds a city and state code from a db.
  def find_city_and_state(zip)
      
    puts 'finding ' + zip.to_s
    
    # stores result
    result = nil
    
    # need to pad zeros in front of the zip 
    padded_zip = sprintf '%05d', (zip)
    
    # load the user agent.
    a = Mechanize.new { |agent|
      agent.user_agent = @user_agent
    }
    
    # convert url to the zip
    actual_url = self.replace_zip_in_url(padded_zip)
    
    # go to page and fetch the string.
    a.get(actual_url) do |p|
    
      # check if the sorry zip code does not exist. node exist.
      error_nodes = p.search('//div[@class="noresults-container"]').length
      
      # need to check if the zip is valid.
      if error_nodes == 0
        # you basically want the first result.
        # so break after you grab it.
        p.search('//div[@id="result-cities"]/p[@class="std-address"]').each do |addr|
          city_state_str = self.city_state_as_hash(padded_zip, addr.text)
          #puts city_state_str.inspect
          result = city_state_str
          break
        end
      else
        puts 'not a valid zip'
      end
    end
    
    # return results.
    # either a nil or a hash containig zip, city, state
    result
  end
  
  # UTILITY FUNCTIONS
  ############################################################################
  
  # swaps out the zip code in the url for the correct one.
  # assumes 00000 is the inital zip in the url
  # assumes web url is defined correclty
  def replace_zip_in_url(code)
    @web_url.gsub(/00000/, code.to_s)
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
  
  # USPS websites returns the result as a string,
  # this will connvert a string into a hash to store in the db. 
  # assumes city state is in this format 'LOS ANGELES CA'
  #
  # so if the zip is 90026 and the string is 'LOS ANGELES CA'
  # it should return {'city' => 'LOS ANGELES', 'state' => 'CA', 'zip_code' => 91770}
  def city_state_as_hash(zip_code, city_state_str)
    #puts zip_code
    #puts city_state_str
    city = /(\w+\s)+/.match(city_state_str)[0].rstrip
    #puts city
    state = /\w\w$/.match(city_state_str)[0]
    #puts state
    #puts zip_code
    
    result_hash = Hash.new
    
    # need rstrip to remove extra spaces on the right side.
    result_hash['CITY'] = /(\w+\s)+/.match(city_state_str)[0].rstrip
    result_hash['STATE'] = /\w\w$/.match(city_state_str)[0]
    result_hash['ZIP'] = zip_code.to_s
    
    result_hash
  end
  
  # just used to test if rspec file read this correct.
  # can ignore.
  def hello
    true
  end
    
end