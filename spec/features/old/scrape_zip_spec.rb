require File.dirname(__FILE__) + '/../spec_helper'
require_relative '../../src/scrape_zip'
require_relative '../../src/scrape_util'

describe ScrapeZip do
  
  describe 'test' do
    before(:each) do
      @web_url = 'https://tools.usps.com/go/ZipLookupAction!input.action'
        
      # db credentials
      @user = 'root'
      @password = 'password'
      @url = 'localhost'
      @db_name = 'test01'
      @table_name = 'ZIP_POP'
    
      # init the scraper
      @s = ScrapeZip.new(:web_url => @web_url, 
                         :url => @url, 
                         :user=> @user, 
                         :password => @password, 
                         :db_name => @db_name,
                         :table_name => @table_name)
    end
    
    # testing if rspec is setup correctly.
    it "hello should be true" do
      @s.hello.should be_true
    end
  end
  
#  describe 'scraper' do
#    before(:each) do
#      @web_url = 'https://tools.usps.com/go/ZipLookupAction!input.action'
#        
#      # db credentials
#      @user = 'root'
#      @password = 'password'
#      @url = 'localhost'
#      @db_name = 'test01'
#      @table_name = 'ZIP_POP'
#    
#      # init the scraper
#      @s = ScrapeZip.new(:web_url => @web_url,
#                         :url => @url, 
#                         :user=> @user, 
#                         :password => @password, 
#                         :db_name => @db_name,
#                         :table_name => @table_name)
#    end
#    
#    describe 'visit url' do
#      xit "method return true" do
#        result = @s.visit_url
#        result.should be_true
#      end
#    end
#    
#    describe 'visit url | click search tab' do
#      xit "method return true" do
#        @s.visit_url
#        result = @s.click_zip_search_tab
#        result.should be_true
#      end
#    end
#    
#    describe 'complete search of zip code' do
#      context 'invalid zips'
#        xit "00000 method return false" do
#          @s.visit_url
#          @s.click_zip_search_tab
#          result = @s.enter_zip_and_search '00000'
#          result.should be_false
#        end
#        
#        xit "0 method return false" do
#          @s.visit_url
#          @s.click_zip_search_tab
#          result = @s.enter_zip_and_search '0'
#          result.should be_false
#        end
#      end
#      
#      context 'valid zips' do
#        xit "method return a string" do
#          @s.visit_url
#          @s.click_zip_search_tab
#          result = @s.enter_zip_and_search '90026'
#          
#          #result.should == 'LOS ANGELES CA'
#          result['STATE'].should == 'CA'
#          result['CITY'].should == 'LOS ANGELES'
#          result['ZIP'].should == '90026'
#        end
#      end
#    end
#  end  
  
  describe 'utility methods' do
    describe 'city_state_as_hash' do
      before(:each) do
        @web_url = 'https://tools.usps.com/go/ZipLookupAction!input.action'
        
        @user = 'root'
        @password = 'password'
        @url = 'localhost'
        @db_name = 'test01'
        @table_name = 'ZIP_POP'
      
        # init the scraper
        @s = ScrapeZip.new(:web_url => @web_url,
                           :url => @url, 
                           :user=> @user, 
                           :password => @password, 
                           :db_name => @db_name,
                           :table_name => @table_name)
      end
      
      xit '90026 LOS ANGELES CA should return a valid hash' do
        result = @s.city_state_as_hash('90026', 'LOS ANGELES CA')
        puts result.inspect
        result['CITY'].should == 'LOS ANGELES'
        result['STATE'].should == 'CA'
        result['ZIP'].should == '90026'
      end
    end
  end
  
end