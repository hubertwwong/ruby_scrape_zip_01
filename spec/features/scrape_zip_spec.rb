require File.dirname(__FILE__) + '/../spec_helper'
require_relative '../../src/scrape_zip'
require_relative '../../src/scrape_util'

describe ScrapeZip do
  
  describe 'test' do
    # testing if rspec is setup correctly.
    it "hello should be true" do
      s = ScrapeZip.new
      s.hello.should be_true
    end
  end
  
  describe 'scraper' do
    before(:each) do
      @s = ScrapeZip.new
    end
    
    describe 'visit url' do
      xit "method return true" do
        result = @s.visit_url
        result.should be_true
      end
    end
    
    describe 'visit url | click search tab' do
      xit "method return true" do
        @s.visit_url
        result = @s.click_zip_search_tab
        result.should be_true
      end
    end
    
    describe 'complete search of zip code' do
      context 'invalid zips'
        xit "00000 method return false" do
          @s.visit_url
          @s.click_zip_search_tab
          result = @s.enter_zip_and_search '00000'
          result.should be_false
        end
        
        xit "0 method return false" do
          @s.visit_url
          @s.click_zip_search_tab
          result = @s.enter_zip_and_search '0'
          result.should be_false
        end
      end
      
      context 'valid zips' do
        it "method return a string" do
          @s.visit_url
          @s.click_zip_search_tab
          result = @s.enter_zip_and_search '90026'
          result.should == 'LOS ANGELES CA'
        end
      end
    end
  
end