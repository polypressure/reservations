require 'test_helper'

#
# We're doing a separate, isolated view test because the
# controller tests are isolated, without view rendering.
#
# This reuses the SitePrism page object (located in
# (test/support/pages/reservations_page.rb) used by the
# feature/acceptance test, test/features/list_and_make_reservations_test.rb.
#
class ReservationViewsTest < ActionView::TestCase

  test "reservations/index displays form and empty list" do
    @reservation_form = ReservationForm.new
    @reservations = []

    render template: 'reservations/index'

    reservations_page = ReservationsPage.new
    reservations_page.load(rendered)

    reservations_page.has_form?
    assert reservations_page.form.has_datetime_field?
    assert reservations_page.form.has_party_size_field?
    assert reservations_page.form.has_first_name_field?
    assert reservations_page.form.has_last_name_field?
    assert reservations_page.form.has_phone_field?
    assert reservations_page.form.has_email_field?
    refute reservations_page.form.has_validation_errors?

    assert reservations_page.has_reservation_list?
    assert reservations_page.has_text?("No reservations have been booked.")
    assert reservations_page.reservation_rows.none?
  end

  test "reservations/index redisplays form with validation errors when given invalid data" do
    @reservation_form = ReservationForm.new
    @reservation_form.validate
    @reservations = []

    render template: 'reservations/index'

    reservations_page = ReservationsPage.new
    reservations_page.load(rendered)

    reservations_page.has_form?
    assert reservations_page.form.has_datetime_field?
    assert reservations_page.form.has_party_size_field?
    assert reservations_page.form.has_first_name_field?
    assert reservations_page.form.has_last_name_field?
    assert reservations_page.form.has_phone_field?
    assert reservations_page.form.has_email_field?
    assert reservations_page.form.has_validation_errors?
    assert reservations_page.has_text? 'Please correct the following problems:'

    assert reservations_page.has_reservation_list?
    assert reservations_page.has_text?("No reservations have been booked.")
    assert reservations_page.reservation_rows.none?
  end

  test "reservations/index displays form and reservations list when reservations exist" do
    @reservation_form = ReservationForm.new
    @reservations = []
    reservation = stubbed_reservation
    8.times { @reservations << reservation }

    render template: 'reservations/index'

    reservations_page = ReservationsPage.new
    reservations_page.load(rendered)

    reservations_page.has_form?
    assert reservations_page.form.has_datetime_field?
    assert reservations_page.form.has_party_size_field?
    assert reservations_page.form.has_first_name_field?
    assert reservations_page.form.has_last_name_field?
    assert reservations_page.form.has_phone_field?
    assert reservations_page.form.has_email_field?
    refute reservations_page.form.has_validation_errors?

    assert reservations_page.has_reservation_list?
    assert_equal 8, reservations_page.reservation_rows.count

    8.times do |n|
      assert_equal [I18n.l(reservation.datetime, format: :day_date_time),
                    reservation.party_size.to_s,
                    reservation.customer.first_name,
                    reservation.customer.last_name,
                    reservation.customer.phone.phony_formatted,
                    reservation.customer.email], reservations_page.row_contents_at(0)
    end
  end


  private

  def stubbed_reservation
    stubbed_customer = stub(
      first_name: 'John',
      last_name: 'Doe',
      phone: '+13125551212',
      email: 'john@test.com',
    )
    stubbed_reservation = stub(
      datetime: Time.zone.now,
      party_size: 5,
      customer: stubbed_customer
    )
  end


end
