require 'helper'
require 'pages'

describe "Watir Page Helper" do
  before(:all) { @browser = Watir::Browser.new :firefox }
  after(:all) { @browser.close }

  it "should raise an error when the expected literal title doesn't match actual title" do
    lambda { PageIncorrectTitle.new @browser, true }.should raise_error("Expected title 'not expected' instead of 'HTML Document Title'")
  end

  it "should raise an error when the expected title pattern doesn't match actual title" do
    lambda { PageIncorrectTitleRegExp.new @browser, true }.should raise_error("Expected title '(?-mix:.*not expected.*)' instead of 'HTML Document Title'")
  end

  it "should go to the correct url on initialize if set in page class, and check correct literal title" do
    page = PageCorrectTitle.new @browser, true
    page.url.should == BasePageClass::TEST_URL
    page.title.should == "HTML Document Title"
  end

  it "should go to the correct url on initialize if set in page class, and check correct title pattern" do
    page = PageCorrectTitleRegExp.new @browser, true
    page.url.should == BasePageClass::TEST_URL
    page.title.should =~ /^HTML Document Title$/
  end

  it "should check the correct literal title of an existing open page" do
    @browser.goto BasePageClass::TEST_URL
    page = PageCorrectTitle.new @browser
    page.title.should == "HTML Document Title"
  end

  it "should go to the correct url on initialize if set in page class, and check correct title pattern" do
    @browser.goto BasePageClass::TEST_URL
    page = PageCorrectTitleRegExp.new @browser, true
    page.title.should =~ /^HTML Document Title$/
  end

  it "should check for the presence of an element when initializing a page" do
    page = PageExpectElement.new @browser
    @browser.text_field(:name => "firstname").exist?.should be_true
  end

  it "should check for the presence of an element when initializing a page - and raise an error if not present" do
    lambda { PageExpectNonElement.new @browser }.should raise_error(/timed out after 1 seconds, waiting for.*doesntexist.*to become present/, Watir::Wait::TimeoutError)
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

  it "should support adding two methods each for dl, dt, dd" do
    page = PageDlDtDd.new @browser, true
    page.definition_list.should == "Succulents\n\n- water-retaining plants adapted to arid climates or soil conditions.\n\nCactus\n\n- plants who distinctive appearance is a result of adaptations to conserve water in dry and/or hot environments."
    page.definition_list_dl.exist?.should be_true
    page.definition_type.should == "Succulents"
    page.definition_type_dt.exist?.should be_true
    page.definition_data.should == "- water-retaining plants adapted to arid climates or soil conditions."
    page.definition_data_dd.exist?.should be_true
  end

  it "should support adding two methods for a form" do
    page = PageForm.new @browser, true
    page.main_form.should == "First name:\nLast name:\nCar model:\nHonda\n\nMazda\n\nToyota\n\nDo you agree?: I agree\nHigh\nMedium\nLow"
    page.main_form_form.exist?.should be_true
  end

  it "should support adding a method for a image" do
    page = PageImage.new @browser, true
    page.succulent_image.exist?.should be_true
  end

  it "should support adding two methods for a li" do
    page = PageLi.new @browser, true
    page.blue_item.should == "Blue"
    page.blue_item_li.exist?.should be_true
  end

  it "should support adding two methods for each heading attribute" do
    page = PageHeadings.new @browser, true
    page.heading_one.should == "Heading One"
    page.heading_two.should == "Heading Two"
    page.heading_three.should == "Heading Three"
    page.heading_four.should == "Heading Four"
    page.heading_five.should == "Heading Five"
    page.heading_six.should == "Heading Six"
    page.heading_one_h1.exist?.should be_true
    page.heading_two_h2.exist?.should be_true
    page.heading_three_h3.exist?.should be_true
    page.heading_four_h4.exist?.should be_true
    page.heading_five_h5.exist?.should be_true
    page.heading_six_h6.exist?.should be_true
  end
end
