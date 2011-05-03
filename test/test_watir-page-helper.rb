require 'helper'
require 'pages'

TEST_URL = "file:///#{File.dirname(__FILE__)}/test.html"

describe "Watir Page Helper" do
  before(:all) { @browser = Watir::Browser.new :firefox }
  after(:all) { @browser.close }

  it "should raise an error when the expected literal title doesn't match actual title" do
    lambda { PageIncorrectTitle.new @browser, true }.should raise_error "Expected title 'not expected' instead of 'HTML Document Title'"
  end

  it "should raise an error when the expected title pattern doesn't match actual title" do
    lambda { PageIncorrectTitleRegExp.new @browser, true }.should raise_error "Expected title '(?-mix:.*not expected.*)' instead of 'HTML Document Title'"
  end

  it "should go to the correct url on initialize if set in page class, and check correct literal title" do
    page = PageCorrectTitle.new @browser, true
    page.url.should == TEST_URL
    page.title.should == "HTML Document Title"
  end

  it "should go to the correct url on initialize if set in page class, and check correct title pattern" do
    page = PageCorrectTitleRegExp.new @browser, true
    page.url.should == TEST_URL
    page.title.should =~ /^HTML Document Title$/
  end

  it "should check the correct literal title of an existing open page" do
    @browser.goto TEST_URL
    page = PageCorrectTitle.new @browser
    page.title.should == "HTML Document Title"
  end

  it "should go to the correct url on initialize if set in page class, and check correct title pattern" do
    @browser.goto TEST_URL
    page = PageCorrectTitleRegExp.new @browser, true
    page.title.should =~ /^HTML Document Title$/
  end

  it "should check for the presence of an element when initializing a page" do
    page = PageExpectElement.new @browser
    @browser.text_field(:name => "firstname").exist?.should be_true
  end

  it "should check for the presence of an element when initializing a page - and raise an error if not present" do
    lambda { PageExpectNonElement.new @browser }.should raise_error "timed out after 1 seconds, waiting for {:name=>\"doesntexist\", :tag_name=>\"input or textarea\", :type=>\"(any text type)\"} to become present", Watir::Wait::TimeoutError
    @browser.text_field(:id => "doesnt exist").exist?.should be_false
  end

  it "should support adding three methods for text fields" do
    page = PageTextFields.new @browser, true
    page.first_name = "Test Name" #set
    page.first_name.should == "Test Name" #check
    page.first_name_text_field.exists?.should be_true #object
  end

  it "should support adding four methods for select lists" do
    page = PageSelectList.new @browser, true
    page.cars = "Mazda" #select
    page.cars.should == "Mazda" #check
    page.cars_selected?("Mazda").should be_true #selected?
    page.cars_select_list.exists?.should be_true #object
  end

  it "should support adding four methods for checkboxes" do
    page = PageCheckbox.new @browser, true
    page.check_agree
    page.agree?.should be_true
    page.uncheck_agree
    page.agree?.should be_false
    page.agree_checkbox.exist?.should be_true
  end

  it "should support adding three methods for radio buttons" do
    page = PageRadioButton.new @browser, true
    page.medium_set?.should be_false
    page.select_medium
    page.medium_set?.should be_true
    page.medium_radio_button.exist?.should be_true
  end

  it "should support adding two methods for buttons" do
    page = PageButton.new @browser, true
    page.submit
    page.submit_button.enabled?.should be_true
  end

  it "should support adding two methods for links" do
    page = PageLink.new @browser, true
    page.info
    page.info_link.exist?.should be_true
  end

  it "should support adding one method for tables" do
    page = PageTable.new @browser, true
    page.test_table.rows.length.should == 1
  end

  it "should support adding two methods for table rows" do
    page = PageTable.new @browser, true
    page.test_table_row_1.should == "Test Table Col 1 Test Table Col 2"
    page.test_table_row_1_row.cells.length.should == 2
  end

  it "should support adding two methods for table cells" do
    page = PageTable.new @browser, true
    page.test_table_row_1_cell_1.should == "Test Table Col 1"
    page.test_table_row_1_cell_1_cell.exist?.should be_true
  end

  it "should support adding two methods for divs" do
    page = PageDiv.new @browser, true
    page.information.should == "This is a header\n\nThis is a paragraph."
    page.information_div.exist?.should be_true
  end

  it "should support adding two methods for spans" do
    page = PageSpan.new @browser, true
    page.background.should == "Some background text in a span."
    page.background_span.exist?.should be_true
  end

  it "should support adding two methods for paragraphs" do
    page = PageParagraph.new @browser, true
    page.paragraph.should == "This is a paragraph."
    page.paragraph_p.exist?.should be_true
  end





end