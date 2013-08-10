require File.dirname(__FILE__) + '/../spec_helper'
require_relative '../../src/scrape_zip'

describe ScrapeZip do
  
  describe 'test' do
    # testing if rspec is setup correctly.
    it "hello should be true" do
      s = ScrapeZip.new
      s.hello.should be_true
    end
  end
  
  describe 'scraper' do
    #before(:each) do
    #  @s = ScrapeZip.new
    #end
    
    describe 'visit url' do
      it "method return true" do
        sz = ScrapeZip.new
        result = sz.visit_url
        result.should be_true
      end
    end
  end
  
end