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
        result = @sz2.enter_zip_and_search(90027)
        result.should == true
      end
    end
    
    describe 'run' do
      it 'valid zips returns a hash' do
        result = @sz2.run
        result.should == true
      end
    end
  end
  
end