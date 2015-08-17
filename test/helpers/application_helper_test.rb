require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase

  test "zurb_class_for returns the correct Zurb Foundation class for a given flash message type" do
    assert_equal 'success', zurb_class_for(:success)
    assert_equal 'success', zurb_class_for(:notice)
    assert_equal 'alert', zurb_class_for(:error)
    assert_equal 'alert', zurb_class_for(:alert)
    assert_equal 'warning', zurb_class_for(:warning)
    assert_equal 'warning', zurb_class_for(:other)
  end


  test "zurb_class_for raises an ArgumentError when given a nil flash message type" do
    assert_raises(ArgumentError) {
      zurb_class_for(nil)
    }
  end


  test "party_size_choices returns the correct range" do
    ReservationBook.stubs(:max_table_size).returns(3)

    assert_equal [["1 person", 1], ["2 people", 2], ["3 people", 3]], party_size_choices
  end

end
