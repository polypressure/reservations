require 'test_helper'

#
# Since models are focused strictly on persistence (with business logic
# and # validation/parsing logic moved to separate objects), these tests
# all interact with the database, with no stubbing.
#
# Note also that these use fixtures instead of factories. I've found the
# tradeoffs generally worthwhile, see thes posts for some elaboration:
#
# http://collectiveidea.com/blog/archives/2014/08/06/time-to-bring-back-fixtures/
# http://brandonhilkert.com/blog/7-reasons-why-im-sticking-with-minitest-and-fixtures-in-rails/
#
class CustomerTest < ActiveSupport::TestCase

  test "has many reservations" do
    r = []
    r << create_reservation(Time.zone.now, 4, customers(:rafa), tables(:table_2_seating_6))
    r << create_reservation(Time.zone.now, 6, customers(:rafa), tables(:table_2_seating_6))
    r << create_reservation(Time.zone.now, 2, customers(:rafa), tables(:table_1_seating_2))

    reservations = customers(:rafa).reservations
    assert_equal r, reservations
  end


  test "has many tables through reservations" do
    create_reservation(Time.zone.now, 4, customers(:rafa), tables(:table_2_seating_6))
    create_reservation(Time.zone.now, 6, customers(:rafa), tables(:table_2_seating_6))
    create_reservation(Time.zone.now, 2, customers(:rafa), tables(:table_1_seating_2))

    tables = customers(:rafa).tables
    assert_equal [tables(:table_2_seating_6), tables(:table_1_seating_2)], tables.distinct
  end

end
