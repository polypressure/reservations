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
class ReservationTest < ActiveSupport::TestCase

  test "in_future scope returns only the reservations in the future" do
    now, r = Time.zone.now, []
    r << create_reservation(now - 1.month, 4, customers(:rafa), tables(:table_1_seating_4))
    r << create_reservation(now - 1.hour, 4, customers(:roger), tables(:table_1_seating_4))
    r << create_reservation(now + 1.hour, 5, customers(:rafa), tables(:table_2_seating_4))
    r << create_reservation(now + 1.day, 5, customers(:hakeem), tables(:table_1_seating_6))
    r << create_reservation(now + 1.week, 2, customers(:roger), tables(:table_1_seating_6))

    upcoming_reservations = Reservation.in_future
    assert_equal r[2..4], upcoming_reservations

  end


  test "by_datetime scope returns reservations sorted by ascending datetime" do
    now, r = Time.zone.now, []
    r << create_reservation(now - 1.hour, 4, customers(:rafa), tables(:table_1_seating_4))
    r << create_reservation(now - 1.month, 4, customers(:roger), tables(:table_1_seating_4))
    r << create_reservation(now + 1.day, 5, customers(:rafa), tables(:table_2_seating_4))
    r << create_reservation(now + 1.week, 5, customers(:hakeem), tables(:table_1_seating_6))
    r << create_reservation(now + 1.hour, 2, customers(:roger), tables(:table_1_seating_6))

    upcoming_reservations = Reservation.by_datetime
    assert_equal [r[1], r[0], r[4], r[2], r[3 ]], upcoming_reservations
  end


  test "upcoming scope returns future reservations sorted by ascending datetime" do
    now, r = Time.zone.now, []
    r <<  create_reservation(now - 1.hour, 4, customers(:rafa), tables(:table_1_seating_4))
    r <<  create_reservation(now - 1.month, 4, customers(:roger), tables(:table_1_seating_4))
    r <<  create_reservation(now + 1.day, 5, customers(:rafa), tables(:table_2_seating_4))
    r <<  create_reservation(now + 1.week, 5, customers(:hakeem), tables(:table_1_seating_6))
    r <<  create_reservation(now + 1.hour, 2, customers(:roger), tables(:table_1_seating_6))

    upcoming_reservations = Reservation.upcoming
    assert_equal [r[4], r[2], r[3 ]], upcoming_reservations
  end


  test "belongs to customer" do
    reservation = create_reservation(Time.zone.now, 4, customers(:rafa), tables(:table_1_seating_4))

    assert_equal customers(:rafa), reservation.customer
    assert_equal reservation, customers(:rafa).reservations.first
  end


  test "belongs to table" do
    reservation = create_reservation(Time.zone.now, 4, customers(:rafa), tables(:table_1_seating_4))

    assert_equal tables(:table_1_seating_4), reservation.table
    assert_equal reservation, tables(:table_1_seating_4).reservations.first
  end


end
