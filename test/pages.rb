class BasePageClass
  include WatirPageHelper

  TEST_URL = "file:///#{File.expand_path(File.dirname(__FILE__))}/test.html"

  def initialize browser, visit = false
    @browser = browser
    goto if visit
      
    expected_element if respond_to? :expected_element
    has_expected_title? if respond_to? :has_expected_title?
  end

  def method_missing sym, *args, &block
    @browser.send sym, *args, &block
  end
end

class PageIncorrectTitle < BasePageClass
  direct_url TEST_URL
  expected_title "not expected"
end

class PageIncorrectTitleRegExp < BasePageClass
  direct_url TEST_URL
  expected_title /.*not expected.*/
end

class PageCorrectTitle < BasePageClass
  direct_url TEST_URL
  expected_title "HTML Document Title"
end

class PageCorrectTitleRegExp < BasePageClass
  direct_url TEST_URL
  expected_title /^HTML Document Title$/
end

class PageExpectElement < BasePageClass
  direct_url TEST_URL
  expected_element :text_field, :name => "firstname"
end

class PageExpectNonElement < BasePageClass
  direct_url TEST_URL
  expected_element(:text_field, {:name => "doesntexist"}, 1)
end

class PageTextFields < BasePageClass
  direct_url TEST_URL
  text_field :first_name, :name => "firstname"
end

class PageSelectList < BasePageClass
  direct_url TEST_URL
  select_list :cars, :name => "cars"
end

class PageCheckbox < BasePageClass
  direct_url TEST_URL
  checkbox :agree, :name => "agree"
end

class PageRadioButton < BasePageClass
  direct_url TEST_URL
  radio_button :medium, :value => "Medium"
end

class PageButton < BasePageClass
  direct_url TEST_URL
  button :submit, :value => "Submit"
end

class PageLink < BasePageClass
  direct_url TEST_URL
  link :info, :text => "Information Link"
end

class PageTable < BasePageClass
  direct_url TEST_URL
  table :test_table, :id => "myTable"
  row(:test_table_row_1) { | test_table |  test_table.tr }
  cell(:test_table_row_1_cell_1) { |test_table_row_1 | test_table_row_1.td }
end

class PageDiv < BasePageClass
  direct_url TEST_URL
  div :information, :id => "myDiv"
end

class PageSpan < BasePageClass
  direct_url TEST_URL
  span :background, :id => "mySpan"
end

class PageParagraph < BasePageClass
  direct_url TEST_URL
  p :paragraph, :id => "myP"
end

class PageDlDtDd < BasePageClass
  direct_url TEST_URL
  dl :definition_list, :id => "myDl"
  dt(:definition_type) { | definition_list_dl | definition_list_dl.dt }
  dd(:definition_data) { | definition_type_dt | definition_type_dt.dd }
end

class PageForm < BasePageClass
  direct_url TEST_URL
  form :main_form, :name => "myForm"
end

class PageImage < BasePageClass
  direct_url TEST_URL
  image :succulent_image, :id => "myImage"
end

class PageLi < BasePageClass
  direct_url TEST_URL
  li :blue_item, :id => "blueLi"
end

class PageHeadings < BasePageClass
  direct_url TEST_URL
  h1 :heading_one, :id => "myh1"
  h2 :heading_two, :id => "myh2"
  h3 :heading_three, :id => "myh3"
  h4 :heading_four, :id => "myh4"
  h5 :heading_five, :id => "myh5"
  h6 :heading_six, :id => "myh6"
end
