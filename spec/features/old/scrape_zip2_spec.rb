require File.dirname(__FILE__) + '/../spec_helper'
require_relative '../../src/scrape_zip2'
require_relative '../../src/scrape_util'

describe ScrapeZip2 do
  
  describe 'test' do
    before(:each) do
      @web_url = 'https://tools.usps.com/go/ZipLookupResultsAction!input.action?resultMode=2&companyName=&address1=&address2=&city=&state=Select&urbanCode=&postalCode=00000&zip='
        
      # db credentials
      @user = 'root'
      @password = 'password'
      @url = 'localhost'
      @db_name = 'test01'
      @table_name = 'ZIP_POP'
    
      # init the scraper
      @sz2 = ScrapeZip2.new(:web_url => @web_url, 
                         :url => @url, 
                         :user=> @user, 
                         :password => @password, 
                         :db_name => @db_name,
                         :table_name => @table_name)
    end
    
    # testing if rspec is setup correctly.
    it "hello should be true" do
      @sz2.hello.should be_true
    end
  end
  
  describe 'main methods' do
    before(:each) do
      @web_url = 'https://tools.usps.com/go/ZipLookupResultsAction!input.action?resultMode=2&companyName=&address1=&address2=&city=&state=Select&urbanCode=&postalCode=00000&zip='
        
      # db credentials
      @user = 'root'
      @password = 'password'
      @url = 'localhost'
      @db_name = 'test01'
      @table_name = 'ZIP_POP'
    
      # init the scraper
      @sz2 = ScrapeZip2.new(:web_url => @web_url, 
                         :url => @url, 
                         :user=> @user, 
                         :password => @password, 
                         :db_name => @db_name,
                         :table_name => @table_name)
    end
    
    describe 'enter_zip_and_search' do
      xit 'valid zips returns a hash' do
        result = @sz2.enter_zip_and_search('00501')
        result.should == true
      end
    end
    
    describe 'run' do
      xit 'valid zips returns a hash' do
        result = @sz2.run
        result.should == true
      end
    end
    
    describe 'run2' do
      it 'valid zips returns a hash' do
        puts 'aaaaaaaaaaaaaaa'
        # weird bug. num params should not have a zero prefix.
        # i think if you do it it picks it up as a hex number or something.
        result = @sz2.run2(5933, 111)
        result.should == true
      end
    end
  end
  
  describe 'util methods' do
    before(:each) do
      @web_url = 'https://tools.usps.com/go/ZipLookupResultsAction!input.action?resultMode=2&companyName=&address1=&address2=&city=&state=Select&urbanCode=&postalCode=00000&zip='
        
      # db credentials
      @user = 'root'
      @password = 'password'
      @url = 'localhost'
      @db_name = 'test01'
      @table_name = 'ZIP_POP'
    
      # init the scraper
      @sz2 = ScrapeZip2.new(:web_url => @web_url, 
                         :url => @url, 
                         :user=> @user, 
                         :password => @password, 
                         :db_name => @db_name,
                         :table_name => @table_name)
    end
    
    describe 'run' do
      describe 'city_state_as_hash' do
        xit 'HOLTSVILLE NY works' do
          result = @sz2.city_state_as_hash('00501', 'HOLTSVILLE NY')
          
          #puts result.inspect
          #puts result['CITY']
          #puts result['STATE']
          #puts result['ZIP']
          
          cur_city = result['CITY']
          cur_state = result['STATE']
          cur_zip = result['ZIP']
          
          cur_city.should == 'HOLTSVILLE'
          cur_state.should == 'NY'
          cur_zip.to_s.should == '00501'
        end
      end
    end
  end
  
end