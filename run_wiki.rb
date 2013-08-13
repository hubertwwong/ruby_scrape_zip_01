# loads the file
require_relative 'src/mechanize_wiki'

# run the scraper
@mw = MechanizeWiki.new
@mw.run_yaml
