require 'watir-webdriver'
require 'watir-page-helper'

class MyPage
  include WatirPageHelper

  direct_url "http://www.google.com"
  expected_element :text_field, :name => "q"
  expected_title "Google"
  text_field :search_box, :name => "q"
  button :search, :name => "btnG"

  def initialize browser, visit = false
    @browser = browser
    goto if visit

    expected_element if respond_to? :expected_element
    has_expected_title? if respond_to? :has_expected_title?
  end

end

browser = Watir::Browser.new :firefox
page = MyPage.new browser, true
page.search_box = "Watirmelon"
page.search
browser.close 