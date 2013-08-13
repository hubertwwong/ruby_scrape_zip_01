require 'rubygems'
require 'mechanize'

a = Mechanize.new { |agent|
  firefox = "'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_4; en-us) AppleWebKit/533.17.8 (KHTML, like Gecko) Version/5.0.1 Safari/533.17.8' );"
  agent.user_agent = firefox
}

url = 'https://tools.usps.com/go/ZipLookupResultsAction!input.action?resultMode=2&companyName=&address1=&address2=&city=&state=Select&urbanCode=&postalCode=91770&zip='

a.get(url) do |page|
  #search_result = page.form_with(:name => 'f') do |search|
  #  search.q = 'Hello world'
  #end.submit

  #page.links.each do |link|
  #  puts link.text
  #end
  
  result = page.search('//div[@id="result-cities"]/p[@class="std-address"]')
  puts result.text
  
  # hypercard
  #at_pop_node = false
  #page.search('//table[@class="infobox geography vcard"]//tr').each do |row|
    
    #if at_pop_node == true
      #puts "node......"
      #puts row.text
      #puts ".."
      #puts row.search('td').text
      #puts ".."
      #puts row.search('th').text
      #puts "node end.."
      #break
    #end
    
    #if row.text.include?('Population')
      #at_pop_node = true
      #puts 'yattaaaaaaaaaaaaaaaaa'
    #end
    
  #end
end