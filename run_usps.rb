# loads the file
require_relative 'src/mechanize_usps'

# db config
# db credentials
#@user = 'root'
#@password = 'password'
#@url = 'localhost'
#@db_name = 'test01'
#@table_name = 'ZIP_POP'

# run the scraper
#@mu = MechanizeUsps.new(:url => @url, 
#                   :user=> @user, 
#                   :password => @password, 
#                   :db_name => @db_name,
#                   :table_name => @table_name)
@mu = MechanizeUsps.new
@mu.run_yaml
