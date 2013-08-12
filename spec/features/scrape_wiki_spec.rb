require File.dirname(__FILE__) + '/../spec_helper'
require_relative '../../src/scrape_wiki'
require_relative '../../src/scrape_util'

describe ScrapeWiki do
  
  describe 'URL METHODS' do
    before(:each) do
      
      # db credentials
      @user = 'root'
      @password = 'password'
      @url = 'localhost'
      @db_name = 'test01'
      @table_name = 'ZIP_POP'
    
      # init the scraper
      @sw = ScrapeWiki.new(:url => @url, 
                         :user=> @user, 
                         :password => @password, 
                         :db_name => @db_name,
                         :table_name => @table_name)
    end
    
    describe 'test' do
      it 'hello should return true' do
        @sw.hello.should == true
      end
    end
    
    describe 'url_suffix_create' do
      it 'DC, LOS ANGELES' do
        result = @sw.url_suffix_create('DC', 'LOS ANGELES')
        result.should == "Los_Angeles,_District_Of_Columbia"
      end
      
      it 'WA, SEATTLE' do
        result = @sw.url_suffix_create('WA', 'Seattle')
        result.should == "Seattle,_Washington"
      end
      
      it 'NY, New York City' do
        result = @sw.url_suffix_create('NY', 'NEW YorK CiTy')
        result.should == "New_York_City,_New_York"
      end
      
      it 'IL, Chicago' do
        result = @sw.url_suffix_create('IL', 'CHICAGO')
        result.should == "Chicago,_Illinois"
      end
    end
    
    describe 'url_create' do
      it 'WA, SEATTLE' do
        result = @sw.url_create('WA', 'Seattle')
        result.should == "Seattle,_Washington"
      end
    end
  end
  
end