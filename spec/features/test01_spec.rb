require File.dirname(__FILE__) + '/../spec_helper'

describe "googe", :type => :feature do
  it "should sign me in" do
    visit "http://www.google.com"
    save_and_open_page
  end
end 