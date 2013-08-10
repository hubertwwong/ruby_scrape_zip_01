require File.dirname(__FILE__) + '/../spec_helper'

describe "usps zip", :type => :feature do
  xit "be present" do
    visit "https://tools.usps.com/go/ZipLookupAction!input.action"
    
    expect(page).to have_content 'Street Address'
    #save_and_open_page
  end
  
  xit "can click on the zip code" do
    visit "https://tools.usps.com/go/ZipLookupAction!input.action"
    click_link("Cities by ZIP Code", exact: false)
    
    expect(page).to have_content 'Get a list of all the cities in a ZIP Code'
  end
  
  xit "unsuccessful zip." do
    visit "https://tools.usps.com/go/ZipLookupAction!input.action"
    click_link("Cities by ZIP Code", exact: false)
    fill_in 'tZip', :with => '00000'
    click_button 'Find'
    
    expect(page).to have_content 'Sorry'
  end
  
  xit "success zip." do
    visit "https://tools.usps.com/go/ZipLookupAction!input.action"
    click_link("Cities by ZIP Code", exact: false)
    fill_in 'tZip', :with => '90026'
    click_button 'Find'
    
    expect(page).to have_content 'Los Angeles'
  end
  
  xit "successful zip also returning city and state." do
    visit "https://tools.usps.com/go/ZipLookupAction!input.action"
    click_link("Cities by ZIP Code", exact: false)
    fill_in 'tZip', :with => '90026'
    click_button 'Find'
    
    foo = first(:xpath, '//div[@id="result-cities"]/p').value()
    
    puts "zzzzzz " + foo
    
    
    first(:xpath, '//div[@id="result-cities"]/p').value().to have_content 'LOS'
    
    
    #find(:xpath, '//li[contains(.//a[@href = "#"]/text(), "foo")]').value
    #puts find(:xpath, '//div#result-cities/h3:first-child').value
    #puts "----"
  end
  
end 