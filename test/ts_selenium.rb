require 'test/unit'
require 'headless'
require 'selenium-webdriver'

class TS_Selenium < Test::Unit::TestCase
  def setup
    @headless = Headless.new
    @headless.start
    @headless.video.start_capture
  end

  def test_google_is_google
    driver = Selenium::WebDriver.for :firefox
    driver.navigate.to "http://google.com"
    
    element = driver.find_element(:name, 'q')
    element.send_keys "Hello WebDriver!"
    element.submit
    
    puts driver.title

    driver.quit
  end

  def teardown
    @headless.video.stop_and_save('test.mov')
  end
end
r
