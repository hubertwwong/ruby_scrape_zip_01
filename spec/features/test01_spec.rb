require File.dirname(__FILE__) + '/../spec_helper'

describe "usps zip", :type => :feature do
  it "be present" do
    visit "https://tools.usps.com/go/ZipLookupAction!input.action"
    
    expect(page).to have_content 'Street Address'
    #save_and_open_page
  end
  
  it "can click on the zip code" do
    visit "https://tools.usps.com/go/ZipLookupAction!input.action"
    click_link("Cities by ZIP Code", exact: false)
    
    expect(page).to have_content 'Get a list of all the cities in a ZIP Code'
  end
  
  it "success zip." do
    visit "https://tools.usps.com/go/ZipLookupAction!input.action"
    click_link("Cities by ZIP Code", exact: false)
    fill_in 'tZip', :with => '91770'
    click_button 'Find'
    
    expect(page).to have_content 'Rosemead'
  end
  
  it "unsuccessful zip." do
    visit "https://tools.usps.com/go/ZipLookupAction!input.action"
    click_link("Cities by ZIP Code", exact: false)
    fill_in 'tZip', :with => '00000'
    click_button 'Find'
    
    expect(page).to have_content 'Sorry'
  end
end 