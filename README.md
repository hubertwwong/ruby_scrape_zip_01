#ABOUT
A interview project that I did to in the span or 4 days or so to figure out the population of
every city of the US.




#Assumptions
============
### Program assumes that a mysql test db is created. 
The scrapers are writing new results as it sees it.

I put the settings in 2 yml files in the config directory. Here are the settings.
```
db_user: root
db_password: password
db_url: localhost
db_name: test01
db_table_name: ZIP_POP
```


### Need the correct gems installed in the system. 
I think you can just run the 'bundle' command and it should install all the necessary gems.




#To Run
============
ruby run_usps.rb

Calls the usps scraper.



ruby run_wiki.rb

Calls the wiki scraper to get the population for cities in the db
You need the usps scrapers to run first so have some values to check 




#Notes
===========

### About
The main parsing programs are called mecahnize_usps and mechanize_wiki.
Both program use the mechanize program to scrape the website.
the program seem to work a lot faster than selenium but it has no javascript so
I had to construct the urls directly, Instead click on buttons and forms.

### Configuration
Left 2 yml files in config directory so db and other settings can be changed.
The config files updates itself as it scrapes a certain zip so you can pick
up where you can left off.

### SQL directory
Left the scraper run for a day or so. I left the zip code scraper run a lot longer
so there are more zip codes than populations but the exported file is what data
I had in the db when I shut things down. I checked a few of the cities.

### Old directory
Scratch code that didn't seem to work ot just used to prototye things. Left it in a
seperate directory so I can reference it if I need it.