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
      xit 'hello should return true' do
        @sw.hello.should == true
      end
    end
    
    describe 'url_suffix_create' do
      xit 'DC, LOS ANGELES' do
        result = @sw.url_suffix_create('DC', 'LOS ANGELES')
        result.should == "Los_Angeles,_District_Of_Columbia"
      end
      
      xit 'WA, SEATTLE' do
        result = @sw.url_suffix_create('WA', 'Seattle')
        result.should == "Seattle,_Washington"
      end
      
      xit 'NY, New York City' do
        result = @sw.url_suffix_create('NY', 'NEW YorK CiTy')
        result.should == "New_York_City,_New_York"
      end
      
      xit 'IL, Chicago' do
        result = @sw.url_suffix_create('IL', 'CHICAGO')
        result.should == "Chicago,_Illinois"
      end
    end
    
    describe 'url_create' do
      xit 'WA, SEATTLE' do
        result = @sw.url_create('WA', 'Seattle')
        result.should == "http://en.wikipedia.org/wiki/Seattle,_Washington"
      end
    end
  end
  
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
    
    describe 'get_population' do
      xit "rosemead, ca" do
        result = @sw.get_population('CA', 'Rosemead')
        result.should == "53,764"
      end
      
      it "new york city, ny" do
        result = @sw.get_population('NY', 'New York City')
        result.should == "8,336,697"
      end
      
      it "seattle, wa" do
        result = @sw.get_population('WA', 'Seattle')
        result.should == "634,535"
      end
      
      xit "los angeles, ca" do
        result = @sw.get_population('CA', 'Los Angeles')
        result.should == "3,857,799"
      end
      
      xit "bad urls... checking" do
        result = @sw.get_population('CA', "Chicago")
        result.should == false
      end
    end
  end
  
end