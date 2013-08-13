require 'rubygems'

require File.dirname(__FILE__) + '/../spec_helper'
require_relative '../../src/mechanize_wiki'

describe MechanizeWiki do
  before(:each) do
    # db credentials
    @user = 'root'
    @password = 'password'
    @url = 'localhost'
    @db_name = 'test01'
    @table_name = 'ZIP_POP'
  
    # init the scraper
    @mw = MechanizeWiki.new(:url => @url, 
                       :user=> @user, 
                       :password => @password, 
                       :db_name => @db_name,
                       :table_name => @table_name)
  end
  
  describe 'test' do
    it 'hello should return true' do
      a = @mw.hello
      a.should == true
    end
  end

  describe 'url methods' do
    describe 'url_suffix_create' do
      it 'DC, LOS ANGELES' do
        result = @mw.url_suffix_create('DC', 'LOS ANGELES')
        result.should == "Los_Angeles,_District_Of_Columbia"
      end
      
      it 'WA, SEATTLE' do
        result = @mw.url_suffix_create('WA', 'Seattle')
        result.should == "Seattle,_Washington"
      end
      
      it 'NY, New York City' do
        result = @mw.url_suffix_create('NY', 'NEW YorK CiTy')
        result.should == "New_York_City,_New_York"
      end
      
      it 'IL, Chicago' do
        result = @mw.url_suffix_create('IL', 'CHICAGO')
        result.should == "Chicago,_Illinois"
      end
    end
    
    describe 'url_create' do
      it 'WA, SEATTLE' do
        result = @mw.url_create('WA', 'Seattle')
        result.should == "http://en.m.wikipedia.org/wiki/Seattle,_Washington"
      end
    end
  end  
  
  describe 'main methods' do
    describe 'get_population' do
      xit "rosemead, ca" do
        result = @mw.get_population('CA', 'Rosemead')
        result.should == "53,764"
      end
      
      xit "new york city, ny" do
        result = @mw.get_population('NY', 'New York City')
        result.should == "8,336,697"
      end
      
      xit "seattle, wa" do
        result = @mw.get_population('WA', 'Seattle')
        result.should == "634,535"
      end
      
      xit "los angeles, ca" do
        result = @mw.get_population('CA', 'Los Angeles')
        result.should == "3,857,799"
      end
      
      xit "seattle, wa" do
        result = @mw.get_population('WA', 'Seattle')
        result.should == "634,535"
      end

      xit "albany, NY" do
        result = @mw.get_population('NY', 'Albany')
        result.should == "97,856"
      end

      
      xit "bad urls... checking" do
        result = @mw.get_population('CA', "Chicago")
        result.should == false
      end
    end
    
    describe 'get pop. saving test' do
      xit "los angeles, ca" do
        pop = @mw.get_population('CA', 'Los Angeles')
        
        # construct result hash.
        puts '> ' + pop
        puts '> ' + pop.gsub(",", '')
        
        result = Hash.new
        result['ZIP'] = 90026
        result['CITY'] = 'LOS ANGELES'
        result['STATE'] = 'CA'
        result['POPULATION'] = pop
        
        @mw.save_to_db(result)
        result.should == "3,857,799"
      end
    end
    
    describe 'run' do
      it "get all the population" do
        result = @mw.run(10)
        result.should == true
      end
    end
  end
  
end