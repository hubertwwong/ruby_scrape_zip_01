require File.dirname(__FILE__) + '/../spec_helper'
require_relative '../../src/scrape_zip2'
require_relative '../../src/scrape_util'

describe ScrapeZip2 do
  
  describe 'fork testing. want to see if you can fork if you specify the display' do
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
      it 'valid zips returns a hash' do
        #fork do
        #  puts "in fork"
        #  sleep 100.0
        #  result = @sz2.run2(50000, 102)
        #end
        #puts "in fork2"
        result = @sz2.run2(60000, 103)
        
        result.should == true
      end
    end
  end
end