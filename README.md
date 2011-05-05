# watir-page-helper

This is a page helper for Watir-WebDriver that allows use easy access to elements.

## Example

Simply define a page such as:

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

    browser = Watir::Browser.new :chrome
    page = MyPage.new browser, true
    page.search_box = "Watirmelon" #This method is created by WatirPageHelper
    page.search #This method is created by WatirPageHelper also
    browser.close

## Main Methods that the Watir Page Helper provides

### Page Methods
* direct_url: allows you to navigate to a page upon initialization, if visit is set to true
* expected_title: allows you to automatically assert the expected title of the page when it is initialized
* expected_element: allows you to initialize the page by looking for a certain element. This is useful for pages that load dynamic content.

### Element Methods
* Element methods for a majority of the Watir-WebDriver supported elements which generate useful helper methods.
* For example: text_field, select_list, radio_button, form, div, span, h1..h6 etc.

## Credits

I originally saw this idea from Jeff Morgan - so full credit goes to him: http://www.cheezyworld.com/

## Contributing to watir-page-helper
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2011 Alister Scott. See LICENSE.txt for
further details.