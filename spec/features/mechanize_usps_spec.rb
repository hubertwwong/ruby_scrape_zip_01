require 'rubygems'

require File.dirname(__FILE__) + '/../spec_helper'
require_relative '../../src/mechanize_usps'

describe MechanizeUsps do
  
  describe 'test' do
    before(:each) do
      # db credentials
      @user = 'root'
      @password = 'password'
      @url = 'localhost'
      @db_name = 'test01'
      @table_name = 'ZIP_POP'
    
      # init the scraper
      @mu = MechanizeUsps.new(:url => @url, 
                         :user=> @user, 
                         :password => @password, 
                         :db_name => @db_name,
                         :table_name => @table_name)
    end
    
    xit 'hello should return true' do
      a = @mu.hello
      a.should == true
    end
  end
  
  describe 'util methods' do
    before(:each) do
      # db credentials
      @user = 'root'
      @password = 'password'
      @url = 'localhost'
      @db_name = 'test01'
      @table_name = 'ZIP_POP'
    
      # init the scraper
      @mu = MechanizeUsps.new(:url => @url, 
                         :user=> @user, 
                         :password => @password, 
                         :db_name => @db_name,
                         :table_name => @table_name)
    end
    
    describe 'city_state_as_hash' do
      xit 'HOLTSVILLE NY works' do
        result = @mu.city_state_as_hash('00501', 'HOLTSVILLE NY')
        
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
  
  describe 'main methods' do
    before(:each) do
      # db credentials
      @user = 'root'
      @password = 'password'
      @url = 'localhost'
      @db_name = 'test01'
      @table_name = 'ZIP_POP'
    
      # init the scraper
      @mu = MechanizeUsps.new(:url => @url, 
                         :user=> @user, 
                         :password => @password, 
                         :db_name => @db_name,
                         :table_name => @table_name)
    end
    
    
    describe 'find_city_and_state' do
      context 'invalid results' do
        xit '00000' do
          result = @mu.find_city_and_state(00000)
          result.should == nil
        end
      end
      
      context 'valid results' do
        xit '90210' do
          result = @mu.find_city_and_state(90210)
          result['CITY'].should == 'BEVERLY HILLS'
          result['STATE'].should == 'CA'
          result['ZIP'].should == '90210'
        end
      end
    end
    
    # main runner..
    describe 'find_and_save_zip' do
      context 'valid results' do
        xit '90211' do
          result = @mu.find_and_save_zip(90211)
          result.should == true
        end
        
        xit '60001' do
          result = @mu.find_and_save_zip(60001)
          result.should == true
        end
      end
      
      context 'invalid results' do
        xit '0' do
          result = @mu.find_and_save_zip(0)
          result.should == false
        end
        
        xit '00000' do
          result = @mu.find_and_save_zip(00000)
          result.should == false
        end
        
        xit '11' do
          result = @mu.find_and_save_zip(11)
          result.should == false
        end
        
        xit '12' do
          result = @mu.find_and_save_zip(12)
          result.should == false
        end
        
        xit '13' do
          result = @mu.find_and_save_zip(13)
          result.should == false
        end
      end
    end
    
    # main runner..
    describe 'runner' do
      xit 'run' do
        result = @mu.run(18200, 2)
      end
      
      it 'run yaml' do
        result = @mu.run_yaml
      end
    end
  end
  
end
