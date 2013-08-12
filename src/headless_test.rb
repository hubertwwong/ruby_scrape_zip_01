require 'rubygems'
require 'headless'
require 'selenium-webdriver'

headless = Headless.new(display: 101, destroy_at_exit: false)
headless.start

driver = Selenium::WebDriver.for :firefox
driver.navigate.to 'http://google.com'
puts driver.title

driver.navigate.to 'http://yahoo.com'
puts driver.title

driver.navigate.to 'http://wikipedia.org'
puts driver.title

headless.destroy