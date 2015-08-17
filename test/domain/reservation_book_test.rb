require 'test_helper'

#
# This tests the ReservationBook domain object, which contains
# all the business logic in the app. The ActiveRecord models
# strictly handle persistence and queries, which are easily
# stubbed here to support testing in isolation.
#
# ReservationBook uses https://github.com/polypressure/outbacker
# to communicate results and outcomes back to the controller,
# which also simplifies testing. Our tests mostly focus on
# verifying that the correct outcome callbacks are triggered
# for thei given input.
#
class ReservationBookTest < ActiveSupport::TestCase

  test "upcoming_reservations" do
    stubbed_reservations = [ stub, stub, stub ]

    #
    # Since this method just delegates through to the Reservation scope,
    # this test is trivial:
    #o
    Reservation.stubs(:upcoming).returns(stubbed_reservations)

    assert_equal stubbed_reservations, ReservationBook.new.upcoming_reservations
  end


  test "runs the failed_validation callback when the form is invalid" do
    reservation_form = stub(invalid?: true)

    ReservationBook.new.make_reservation(reservation_form) do |on_outcome|
      on_outcome.of(:successful_booking) do |reservation|
        fail ":successful_booking is the wrong outcome"
      end

      on_outcome.of(:no_availability) do |form|
        fail ":no_availability is the wrong outcome"
      end

      on_outcome.of(:failed_validation) do |form|
        pass "correct outcome"
        assert_equal reservation_form, form
      end
    end
  end


  test "runs the no_availability callback when the form is valid but no open tables" do
    reservation_form = stub(invalid?: false, party_size: 8, datetime: Time.zone.now)
    Table.stubs(:open).returns([])

    ReservationBook.new.make_reservation(reservation_form) do |on_outcome|
      on_outcome.of(:successful_booking) do |reservation|
        fail ":successful_booking is the wrong outcome"
      end

      on_outcome.of(:no_availability) do |form|
        pass "correct outcome"
        assert_equal reservation_form, form
      end

      on_outcome.of(:failed_validation) do |form|
        fail ":failed_validation is the wrong outcome"
      end
    end
  end

  #
  # This test requires the most stubbing, which is usually an indicator that
  # this method might have too many dependencies. More specifically, we're
  # having to stub a method in three different ActiveRecord models. This is
  # mostly a consequence of the data being normalized/split across three
  # tables, so for now not worrying about reducing the dependencies.
  #
  # Also note that this is the one place we're bothering with mocks, and
  # verifying that methods were called on those mocks. That's because the
  # messages sent here (to ask the Customer and Reservations to create
  # records) are really the key outputs of this method.
  #
  test "runs the successful_booking callback when the form is valid and there are open tables" do
    reservation_form = stub(
      invalid?: false,
      party_size: 8, datetime: Time.zone.now,
      first_name: 'John', last_name: 'Doe',
      phone: '(312) 555-1212', email: 'joe@test.com'
    )
    Table.stubs(:open).returns([stubbed_table = stub])
    Customer.expects(:find_or_create_by).
      with(first_name: reservation_form.first_name,
           last_name: reservation_form.last_name,
           phone: reservation_form.phone,
           email: reservation_form.email).
      returns(stubbed_customer = stub)
    Reservation.expects(:create!).
      with(datetime: reservation_form.datetime,
           party_size: reservation_form.party_size,
           table: stubbed_table,
           customer: stubbed_customer).
      returns(stubbed_reservation = stub)

    ReservationBook.new.make_reservation(reservation_form) do |on_outcome|
      on_outcome.of(:successful_booking) do |reservation|
        pass "correct outcome"
        assert_equal stubbed_reservation, reservation
      end

      on_outcome.of(:no_availability) do |form|
        fail ":no_availability is the wrong outcome"
      end

      on_outcome.of(:failed_validation) do |form|
        fail ":failed_validation is the wrong outcome"
      end
    end
  end


  test "max_table_size returns the largest seat size of all tables" do

    #
    # Since this method just delegates through to the Table scope,
    # this test is trivial:
    #o
    Table.stubs(:maximum).returns(8)

    assert_equal 8, ReservationBook.max_table_size
  end

end
