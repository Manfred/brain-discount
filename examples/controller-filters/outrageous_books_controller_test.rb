require 'active_support/all'

class ApplicationController
  class << self
    def before_filter(*)
    end
  end
end

class Book; end

require_relative 'outrageous_books_controller'

if __FILE__ == $0
  require 'minitest/autorun'

  class BooksControllerTest < Minitest::Test
    def setup
      @controller = BooksController.new
    end

    def test_resource_class_name
      assert_equal 'Book', @controller.send(:resource_class_name)
    end

    def test_resource
      assert_equal Book, @controller.send(:resource_class)
    end
  end
end