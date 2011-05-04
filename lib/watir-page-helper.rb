# A helper mixin to make accessing web elements via Watir-WebDriver easier.
## This module assumes there is a @browser variable available.
module WatirPageHelper

  # A method that is called when this Module is included into a class
  # @param [Class] cls The class that this module is being included in the literal expected title for the page
  # @return [Nil]
  def self.included(cls)
    cls.extend ClassMethods
  end

  # A collection of class methods that generate helper methods that are mixed into a calling class.
  module ClassMethods

    # Creates a method that compares the expected_title of a page against the actual.
    # @param [String] expected_title the literal expected title for the page
    # @param [Regexp] expected_title the expected title pattern for the page
    # @return [Nil]
    # @raise An exception if expected_title does not match actual title
    #
    # @example Specify 'Google' as the expected title of a page
    #   expected_title "Google"
    #   page.has_expected_title?
    def expected_title expected_title
      define_method("has_expected_title?") do
        has_expected_title = expected_title.kind_of?(Regexp) ? expected_title =~ @browser.title : expected_title == @browser.title
        raise "Expected title '#{expected_title}' instead of '#{@browser.title}'" unless has_expected_title
      end
    end
    
    # Creates a method that provides a way to initialize a page based upon an expected element.
    # This is useful for pages that load dynamic content.
    # @param [Symbol] type the type of element you are expecting
    # @param [Hash] identifier the name, value pair used to identify the object
    # @param [optional, Integer] timeout default value is 30 seconds
    # @return [Nil]
    #
    # @example Specify a text box as expected on the page within 10 seconds
    #   expected_element(:text_field, :name => "firstname", 10)
    #   page.expected_element
    def expected_element type, identifier, timeout=30
      define_method("expected_element") do
        @browser.send("#{type.to_s}", identifier).wait_until_present timeout
      end
    end

    # Provides a way to define a direct URL for a page, and creates a method for the page to go to that URL.
    # @param [String] url the URL to directly access the page
    # @return [Nil]
    #
    # @example Set the direct URL for the Google Home Page
    #   direct_url "http://www.google.com"
    #   page.goto # navigates to the Google URL
    def direct_url url
      define_method("goto") do
        @browser.goto url
      end
    end

    # Generates three text_field methods to:
    # * set a text field;
    # * get a text field's value; and
    # * return the text_field element.
    #
    # @param [Symbol] name The name of the text field element (used to generate the methods)
    # @param [optional, Hash] identifier A set of key, value pairs to identify the element
    # @param block
    # @return [Nil]
    #
    # @example Specify a text field to generate methods
    #   text_field first_name, :name => "firstname"
    #   page.first_name = "Finley" #set
    #   page.first_name.should == "Finley" #check
    #   page.first_name_text_field.exists?.should be_true #object
    def text_field name, identifier=nil, &block
      define_method(name) do
        self.send("#{name}_text_field").value
      end
      define_method("#{name}=") do |value|
        self.send("#{name}_text_field").set value
      end
      define_method("#{name}_text_field") do
        block ? block.call(@browser) : @browser.text_field(identifier)
      end
    end

    # Generates four select_list methods to:
    # * get the value specified in a select_list
    # * select a value in a select list;
    # * see whether a value is selected; and
    # * return the select_list element.
    #
    # @param [Symbol] name The name of the select_list element (used to generate the methods)
    # @param [optional, Hash] identifier A set of key, value pairs to identify the element
    # @param block
    # @return [Nil]
    #
    # @example Specify a select list to generate methods
    #   select_list :cars, :name => "cars"
    #   page.cars = "Mazda" #select
    #   page.cars.should == "Mazda" #check
    #   page.cars_selected?("Mazda").should be_true #selected?
    #   page.cars_select_list.exists?.should be_true #object
    def select_list name, identifier=nil, &block
      define_method(name) do
        self.send("#{name}_select_list").value
      end
      define_method("#{name}=") do |value|
        self.send("#{name}_select_list").select(value)
      end
      define_method("#{name}_selected?") do |value|
        self.send("#{name}_select_list").selected?(value)
      end
      define_method("#{name}_select_list") do
        block ? block.call(@browser) : @browser.select_list(identifier)
      end
    end

    # Generates four checkbox methods to:
    # * check the checkbox;
    # * uncheck the checkbox;
    # * see whether a the checkbox is checked; and
    # * return the checkbox element.
    #
    # @param [Symbol] name The name of the checkbox element (used to generate the methods)
    # @param [optional, Hash] identifier A set of key, value pairs to identify the element
    # @param block
    # @return [Nil]
    #
    # @example Specify a checkbox to generate methods
    #   checkbox :agree, :name => "agree"
    #   page.check_agree
    #   page.agree?.should be_true
    #   page.uncheck_agree
    #   page.agree?.should be_false
    #   page.agree_checkbox.exist?.should be_true
    def checkbox name, identifier=nil, &block
      define_method("check_#{name}") do
        self.send("#{name}_checkbox").set
      end
      define_method("uncheck_#{name}") do
        self.send("#{name}_checkbox").clear
      end
      define_method("#{name}?") do
        self.send("#{name}_checkbox").set?
      end
      define_method("#{name}_checkbox") do
        block ? block.call(@browser) : @browser.checkbox(identifier)
      end
    end

    # Generates three radio button methods to:
    # * select a radio button;
    # * see whether a radio button is selected; and
    # * return the radio button element.
    #
    # @param [Symbol] name The name of the radio button element (used to generate the methods)
    # @param [optional, Hash] identifier A set of key, value pairs to identify the element
    # @param block
    # @return [Nil]
    #
    # @example Specify a radio button to generate methods
    #   radio_button :medium, :value => "Medium"
    #   page.select_medium
    #   page.medium_set?.should be_true
    #   page.medium_radio_button.exist?.should be_true
    def radio_button name, identifier=nil, &block
      define_method("select_#{name}") do
        self.send("#{name}_radio_button").set
      end
      define_method("#{name}_set?") do
        self.send("#{name}_radio_button").set?
      end
      define_method("#{name}_radio_button")  do
        block ? block.call(@browser) : @browser.radio(identifier)
      end
    end

    # Generates two button methods to:
    # * click a button;
    # * return the button element.
    #
    # @param [Symbol] name The name of the button element (used to generate the methods)
    # @param [optional, Hash] identifier A set of key, value pairs to identify the element
    # @param block
    # @return [Nil]
    #
    # @example Specify a button to generate methods
    #   button :submit, :value => "Submit"
    #   page = PageButton.new @browser, true
    #   page.submit
    #   page.submit_button.enabled?.should be_true
    def button name, identifier=nil, &block
      define_method(name) do
        self.send("#{name}_button").click
      end
      define_method("#{name}_button") do
        block ? block.call(@browser) : @browser.button(identifier)
      end
    end

    # Generates two link methods to:
    # * click a link;
    # * return the link element.
    #
    # @param [Symbol] name The name of the link element (used to generate the methods)
    # @param [optional, Hash] identifier A set of key, value pairs to identify the element
    # @param block
    # @return [Nil]
    #
    # @example Specify a link to generate methods
    #   link :info, :text => "Information Link"
    #   page.info
    #   page.info_link.exist?.should be_true
    def link name, identifier=nil, &block
      define_method(name) do
        self.send("#{name}_link").click
      end
      define_method("#{name}_link") do
        block ? block.call(@browser) : @browser.link(identifier)
      end
    end

    # Generates a table method to return a table element.
    # @param [Symbol] name The name of the table element (used to generate the method)
    # @param [optional, Hash] identifier A set of key, value pairs to identify the element
    # @param block
    # @return [Nil]
    #
    # @example Specify a table to generate a method
    #   table :test_table, :id => "myTable"
    #   page.test_table.rows.length.should == 1
    def table name, identifier=nil, &block
      define_method(name) do
        block ? block.call(@browser) : @browser.table(identifier)
      end
    end

    # Generates two row methods to:
    # * return the text from a table row;
    # * return the row element.
    #
    # @param [Symbol] name The name of the row element (used to generate the methods)
    # @param [optional, Hash] identifier A set of key, value pairs to identify the element
    # @param block
    # @return [Nil]
    #
    # @example Specify a row to generate methods
    #  row(:test_table_row_1) { | test_table |  test_table.tr }
    #  page.test_table_row_1.should == "Test Table Col 1 Test Table Col 2"
    #  page.test_table_row_1_row.cells.length.should == 2
    def row name, identifier=nil, &block
      define_method(name) do
        self.send("#{name}_row").text
      end
      define_method("#{name}_row") do
        block ? block.call(@browser) : @browser.tr(identifier)
      end
    end

    # Generates two row methods to:
    # * return the text from a table cell;
    # * return the cell element.
    #
    # @param [Symbol] name The name of the cell element (used to generate the methods)
    # @param [optional, Hash] identifier A set of key, value pairs to identify the element
    # @param block
    # @return [Nil]
    #
    # @example Specify a cell to generate methods
    #  cell(:test_table_row_1_cell_1) { |test_table_row_1 | test_table_row_1.td }
    #  page.test_table_row_1_cell_1.should == "Test Table Col 1"
    #  page.test_table_row_1_cell_1_cell.exist?.should be_true
    def cell name, identifier=nil, &block
      define_method(name) do
        self.send("#{name}_cell").text
      end
      define_method("#{name}_cell") do
        block ? block.call(@browser) : @browser.td(identifier)
      end
    end

    # Generates two div methods to:
    # * return the text from a div;
    # * return the div element.
    #
    # @param [Symbol] name The name of the div element (used to generate the methods)
    # @param [optional, Hash] identifier A set of key, value pairs to identify the element
    # @param block
    # @return [Nil]
    #
    # @example Specify a div to generate methods
    #  div :information, :id => "myDiv"
    #  page.information.should == "This is a header\n\nThis is a paragraph."
    #  page.information_div.exist?.should be_true
    def div name, identifier=nil, &block
      define_method(name) do
        self.send("#{name}_div").text
      end
      define_method("#{name}_div") do
        block ? block.call(@browser) : @browser.div(identifier)
      end
    end

    # Generates two span methods to:
    # * return the text from a span;
    # * return the span element.
    #
    # @param [Symbol] name The name of the span element (used to generate the methods)
    # @param [optional, Hash] identifier A set of key, value pairs to identify the element
    # @param block
    # @return [Nil]
    #
    # @example Specify a span to generate methods
    #  span :information, :id => "mySpan"
    #  page.information.should == "This is a header\n\nThis is a paragraph."
    #  page.information_span.exist?.should be_true
    def span name, identifier=nil, &block
      define_method(name) do
        self.send("#{name}_span").text
      end
      define_method("#{name}_span") do
        block ? block.call(@browser) : @browser.span(identifier)
      end
    end

    # Generates two paragraph methods to:
    # * return the text from a p;
    # * return the p element.
    #
    # @param [Symbol] name The name of the p element (used to generate the methods)
    # @param [optional, Hash] identifier A set of key, value pairs to identify the element
    # @param block
    # @return [Nil]
    #
    # @example Specify a paragraph to generate methods
    #  p :paragraph, :id => "myP"
    #  page.paragraph.should == "This is a paragraph."
    #  page.paragraph_p.exist?.should be_true
    def p name, identifier=nil, &block
      define_method(name) do
        self.send("#{name}_p").text
      end
      define_method("#{name}_p") do
        block ? block.call(@browser) : @browser.p(identifier)
      end
    end

    # Generates two dd methods to:
    # * return the text from a dd;
    # * return the dd element.
    #
    # @param [Symbol] name The name of the dd element (used to generate the methods)
    # @param [optional, Hash] identifier A set of key, value pairs to identify the element
    # @param block
    # @return [Nil]
    #
    # @example Specify a dd to generate methods
    #  dd :definition_data, :id => "myDD"
    #  page.definition_data.should == "This is a dd"
    #  page.definition_data_dd.exist?.should be_true
    def dd name, identifier=nil, &block
      define_method(name) do
        self.send("#{name}_dd").text
      end
      define_method("#{name}_dd") do
        block ? block.call(@browser) : @browser.dd(identifier)
      end
    end

    # Generates two dl methods to:
    # * return the text from a dl;
    # * return the dl element.
    #
    # @param [Symbol] name The name of the dl element (used to generate the methods)
    # @param [optional, Hash] identifier A set of key, value pairs to identify the element
    # @param block
    # @return [Nil]
    #
    # @example Specify a dl to generate methods
    #  dl :definition_list, :id => "myDL"
    #  page.definition_list.should == "This is a dl"
    #  page.definition_list_dl.exist?.should be_true
    def dl name, identifier=nil, &block
      define_method(name) do
        self.send("#{name}_dl").text
      end
      define_method("#{name}_dl") do
        block ? block.call(@browser) : @browser.dl(identifier)
      end
    end

    # Generates two dt methods to:
    # * return the text from a dt;
    # * return the dt element.
    #
    # @param [Symbol] name The name of the dt element (used to generate the methods)
    # @param [optional, Hash] identifier A set of key, value pairs to identify the element
    # @param block
    # @return [Nil]
    #
    # @example Specify a dt to generate methods
    #  dt :definition_type, :id => "myDT"
    #  page.definition_type.should == "This is a dt"
    #  page.definition_type_dt.exist?.should be_true
    def dt name, identifier=nil, &block
      define_method(name) do
        self.send("#{name}_dt").text
      end
      define_method("#{name}_dt") do
        block ? block.call(@browser) : @browser.dt(identifier)
      end
    end

    # Generates two form methods to:
    # * return the text from a form;
    # * return the form element.
    #
    # @param [Symbol] name The name of the form element (used to generate the methods)
    # @param [optional, Hash] identifier A set of key, value pairs to identify the element
    # @param block
    # @return [Nil]
    #
    # @example Specify a form to generate methods
    #  form :details, :id => "myForm"
    #  page.details.should == "My Form Text"
    #  page.details_form.exist?.should be_true
    def form name, identifier=nil, &block
      define_method(name) do
        self.send("#{name}_form").text
      end
      define_method("#{name}_form") do
        block ? block.call(@browser) : @browser.form(identifier)
      end
    end

    # Generates a method to return an image element
    #
    # @param [Symbol] name The name of the image element (used to generate the methods)
    # @param [optional, Hash] identifier A set of key, value pairs to identify the element
    # @param block
    # @return [Nil]
    #
    # @example Specify a image to generate method
    #  image :succulent, :id => "mySucculentImage"
    #  page.succulent.exist?.should be_true
    def image name, identifier=nil, &block
      define_method(name) do
        block ? block.call(@browser) : @browser.image(identifier)
      end
    end

    # Generates two li methods to:
    # * return the text from a li;
    # * return the li element.
    #
    # @param [Symbol] name The name of the li element (used to generate the methods)
    # @param [optional, Hash] identifier A set of key, value pairs to identify the element
    # @param block
    # @return [Nil]
    #
    # @example Specify a li to generate methods
    #  li :item, :id => "myLi"
    #  page.item.should == "My List Item Text"
    #  page.item_li.exist?.should be_true
    def li name, identifier=nil, &block
      define_method name do
        self.send("#{name}_li").text
      end
      define_method "#{name}_li" do
        block ? block.call(@browser) : @browser.li(identifier)
      end
    end

    # Generates two h1 methods to:
    # * return the text from a h1;
    # * return the h1 element.
    #
    # @param [Symbol] name The name of the h1 element (used to generate the methods)
    # @param [optional, Hash] identifier A set of key, value pairs to identify the element
    # @param block
    # @return [Nil]
    #
    # @example Specify a h1 to generate methods
    #  h1 :heading_one, :id => "myH1"
    #  page.heading_one.should == "My Heading One"
    #  page.heading_one_h1.exist?.should be_true
    def h1 name, identifier=nil, &block
      define_method(name) do
        self.send("#{name}_h1").text
      end
      define_method("#{name}_h1") do
        block ? block.call(@browser) : @browser.h1(identifier)
      end
    end

    # Generates two h2 methods to:
    # * return the text from a h2;
    # * return the h2 element.
    #
    # @param [Symbol] name The name of the h2 element (used to generate the methods)
    # @param [optional, Hash] identifier A set of key, value pairs to identify the element
    # @param block
    # @return [Nil]
    #
    # @example Specify a h1 to generate methods
    #  h2 :heading_two, :id => "myH2"
    #  page.heading_two.should == "My Heading Two"
    #  page.heading_two_h2.exist?.should be_true
    def h2 name, identifier=nil, &block
      define_method(name) do
        self.send("#{name}_h2").text
      end
      define_method("#{name}_h2") do
        block ? block.call(@browser) : @browser.h2(identifier)
      end
    end

    # Generates two h3 methods to:
    # * return the text from a h3;
    # * return the h3 element.
    #
    # @param [Symbol] name The name of the h3 element (used to generate the methods)
    # @param [optional, Hash] identifier A set of key, value pairs to identify the element
    # @param block
    # @return [Nil]
    #
    # @example Specify a h3 to generate methods
    #  h2 :heading_three, :id => "myH3"
    #  page.heading_three.should == "My Heading Three"
    #  page.heading_three_h3.exist?.should be_true
    def h3 name, identifier=nil, &block
      define_method(name) do
        self.send("#{name}_h3").text
      end
      define_method("#{name}_h3") do
        block ? block.call(@browser) : @browser.h3(identifier)
      end
    end

    # Generates two h4 methods to:
    # * return the text from a h4;
    # * return the h4 element.
    #
    # @param [Symbol] name The name of the h4 element (used to generate the methods)
    # @param [optional, Hash] identifier A set of key, value pairs to identify the element
    # @param block
    # @return [Nil]
    #
    # @example Specify a h4 to generate methods
    #  h4 :heading_four, :id => "myH4"
    #  page.heading_four.should == "My Heading Four"
    #  page.heading_four_h4.exist?.should be_true
    def h4 name, identifier=nil, &block
      define_method(name) do
        self.send("#{name}_h4").text
      end
      define_method("#{name}_h4") do
        block ? block.call(@browser) : @browser.h4(identifier)
      end
    end

    # Generates two h5 methods to:
    # * return the text from a h5;
    # * return the h5 element.
    #
    # @param [Symbol] name The name of the h5 element (used to generate the methods)
    # @param [optional, Hash] identifier A set of key, value pairs to identify the element
    # @param block
    # @return [Nil]
    #
    # @example Specify a h5 to generate methods
    #  h2 :heading_five, :id => "myH5"
    #  page.heading_five.should == "My Heading Five"
    #  page.heading_five_h5.exist?.should be_true
    def h5 name, identifier=nil, &block
      define_method(name) do
        self.send("#{name}_h5").text
      end
      define_method("#{name}_h5") do
        block ? block.call(@browser) : @browser.h5(identifier)
      end
    end

    # Generates two h6 methods to:
    # * return the text from a h6;
    # * return the h6 element.
    #
    # @param [Symbol] name The name of the h6 element (used to generate the methods)
    # @param [optional, Hash] identifier A set of key, value pairs to identify the element
    # @param block
    # @return [Nil]
    #
    # @example Specify a h6 to generate methods
    #  h2 :heading_six, :id => "myH6"
    #  page.heading_six.should == "My Heading Six"
    #  page.heading_six_h6.exist?.should be_true
    def h6 name, identifier=nil, &block
      define_method(name) do
         self.send("#{name}_h6").text
      end
      define_method("#{name}_h6") do
        block ? block.call(@browser) : @browser.h6(identifier)
      end
    end
  end
end