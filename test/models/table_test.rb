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
class TableTest < ActiveSupport::TestCase

  test "invalid when no seat count is provided" do
    table = Table.new
    table.invalid?
  end

  test "seating_at_least scope returns no tables for parties that are too large" do
    assert_equal 0, Table.seating_at_least(100).count
  end


  test "seating_at_least scope returns all tables for party of 1" do
    all_tables = Table.seating_at_least(1)

    assert_equal Table.count, all_tables.count
  end


  test "seating_at_least scope returns only the tables that can seat a specified size" do
    tables_seating_at_least_4 = Table.seating_at_least(4)

    assert_all tables: tables_seating_at_least_4, seat_at_least: 4, count: 10
    assert_equal [tables(:table_1_seating_4),
                  tables(:table_2_seating_4),
                  tables(:table_3_seating_4),
                  tables(:table_4_seating_4),
                  tables(:table_5_seating_4),
                  tables(:table_1_seating_6),
                  tables(:table_2_seating_6),
                  tables(:table_3_seating_6),
                  tables(:table_1_seating_8),
                  tables(:table_2_seating_8)], tables_seating_at_least_4
  end


  test "has many reservations" do
    aug_30_7pm, r = Time.zone.parse('Aug 30, 2015 7:00 pm'), []
    r << create_reservation(aug_30_7pm, 4, customers(:roger), tables(:table_1_seating_4))
    r << create_reservation(aug_30_7pm + 2.hours, 5, customers(:rafa), tables(:table_1_seating_4))
    r << create_reservation(aug_30_7pm + 1.day, 5, customers(:hakeem), tables(:table_1_seating_4))

    assert_equal r, tables(:table_1_seating_4).reservations
  end


  test "has many customers through reservations" do
    aug_30_7pm = Time.zone.parse('Aug 30, 2015 7:00 pm')
    create_reservation(aug_30_7pm, 4, customers(:roger), tables(:table_1_seating_4))
    create_reservation(aug_30_7pm + 2.hours, 5, customers(:rafa), tables(:table_1_seating_4))
    create_reservation(aug_30_7pm + 1.day, 5, customers(:hakeem), tables(:table_1_seating_4))

    customers = tables(:table_1_seating_4).customers

    assert_equal [customers(:roger), customers(:rafa), customers(:hakeem)], customers
  end

  #
  # Following are tests for the "open" scope, which returns the open tables that
  # seat at least the given party size on the requested date, and iss the meat of the
  # app's functionality. The tests are all dependent on the contents
  # of fixtures/tables.yml...
  #

  test "returns no open tables when all have been booked for the party size on the given date" do
    aug_31_8pm = Time.zone.parse('Aug 31, 2015 8:00 pm')
    create_reservation(aug_31_8pm, 8, customers(:roger), tables(:table_1_seating_8))
    create_reservation(aug_31_8pm, 8, customers(:rafa), tables(:table_2_seating_8))

    assert_equal 0, Table.open(for_party_of: 7, on: aug_31_8pm).count
    assert_equal 0, Table.open(for_party_of: 8, on: aug_31_8pm).count
  end


  test "returns all the tables that can seat a given party size/date when no reservations have been made" do
    aug_31_8pm = Time.zone.parse('Aug 31, 2015 8:00 pm')

    assert_all tables: Table.open(for_party_of: 2, on: aug_31_8pm), seat_at_least: 2, count: 13
    assert_all tables: Table.open(for_party_of: 4, on: aug_31_8pm), seat_at_least: 4, count: 10
    assert_all tables: Table.open(for_party_of: 6, on: aug_31_8pm), seat_at_least: 6, count: 5
    assert_all tables: Table.open(for_party_of: 8, on: aug_31_8pm), seat_at_least: 8, count: 2
    assert_all tables: Table.open(for_party_of: 10, on: aug_31_8pm), seat_at_least: 10, count: 0
  end


  test "returns no open tables when all tables of all sizes have been booked on the given date" do
    aug_31_8pm = Time.zone.parse('Aug 31, 2015 8:00 pm')
    create_reservation(aug_31_8pm, 8, customers(:roger), tables(:table_1_seating_2))
    create_reservation(aug_31_8pm, 8, customers(:roger), tables(:table_2_seating_2))
    create_reservation(aug_31_8pm, 8, customers(:roger), tables(:table_3_seating_2))
    create_reservation(aug_31_8pm, 8, customers(:roger), tables(:table_1_seating_4))
    create_reservation(aug_31_8pm, 8, customers(:roger), tables(:table_2_seating_4))
    create_reservation(aug_31_8pm, 8, customers(:roger), tables(:table_3_seating_4))
    create_reservation(aug_31_8pm, 8, customers(:roger), tables(:table_4_seating_4))
    create_reservation(aug_31_8pm, 8, customers(:roger), tables(:table_5_seating_4))
    create_reservation(aug_31_8pm, 8, customers(:roger), tables(:table_1_seating_6))
    create_reservation(aug_31_8pm, 8, customers(:roger), tables(:table_2_seating_6))
    create_reservation(aug_31_8pm, 8, customers(:roger), tables(:table_3_seating_6))
    create_reservation(aug_31_8pm, 8, customers(:roger), tables(:table_1_seating_8))
    create_reservation(aug_31_8pm, 8, customers(:roger), tables(:table_2_seating_8))

    assert_equal 0, Table.open(for_party_of: 1, on: aug_31_8pm).count
    assert_equal 0, Table.open(for_party_of: 2, on: aug_31_8pm).count
    assert_equal 0, Table.open(for_party_of: 3, on: aug_31_8pm).count
    assert_equal 0, Table.open(for_party_of: 4, on: aug_31_8pm).count
    assert_equal 0, Table.open(for_party_of: 5, on: aug_31_8pm).count
    assert_equal 0, Table.open(for_party_of: 6, on: aug_31_8pm).count
    assert_equal 0, Table.open(for_party_of: 7, on: aug_31_8pm).count
    assert_equal 0, Table.open(for_party_of: 8, on: aug_31_8pm).count
  end


  test "returns the open tables that can seat a given party size/date when some have been booked" do
    aug_30_7pm = Time.zone.parse('Aug 30, 2015 7:00 pm')
    create_reservation(aug_30_7pm, 4, customers(:roger), tables(:table_1_seating_4))
    create_reservation(aug_30_7pm, 5, customers(:rafa), tables(:table_2_seating_4))
    create_reservation(aug_30_7pm, 5, customers(:hakeem), tables(:table_1_seating_6))

    open_tables = Table.open(for_party_of: 4, on: aug_30_7pm)

    assert_all tables: Table.open(for_party_of: 4, on: aug_30_7pm), seat_at_least: 4, count: 7
    assert_equal [tables(:table_3_seating_4),
                  tables(:table_4_seating_4),
                  tables(:table_5_seating_4),
                  tables(:table_2_seating_6),
                  tables(:table_3_seating_6),
                  tables(:table_1_seating_8),
                  tables(:table_2_seating_8)], open_tables
  end


  private

  #
  # Helper assertion, assert all the given tables seat at least the
  # specified amount, and that the number of tables is equal
  # the specified count.
  #
  def assert_all(tables:, seat_at_least:, count:)
    assert_equal count, tables.count
    tables.each do |table|
      assert table.seats >= seat_at_least
    end
  end

end
