require_relative 'scrape_zip2'
require_relative 'scrape_util'


@web_url = 'https://tools.usps.com/go/ZipLookupResultsAction!input.action?resultMode=2&companyName=&address1=&address2=&city=&state=Select&urbanCode=&postalCode=00000&zip='
  
# db credentials
@user = 'root'
@password = 'password'
@url = 'localhost'
@db_name = 'test01'
@table_name = 'ZIP_POP'

# init the scraper
@sz2 = ScrapeZip2.new(:web_url => @web_url, 
                   :url => @url, 
                   :user=> @user, 
                   :password => @password, 
                   :db_name => @db_name,
                   :table_name => @table_name)
                   
@sz2.run2(40000, 140)