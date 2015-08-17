require "test_helper"

#
# These feature/acceptance tests follow the Page Object pattern, using
# the SitePrism (https://github.com/natritmeyer/site_prism) gem.
# They also use https://github.com/cantierecreativo/tedium to simplify
# filling out and submitting forms.
#
# Page objects are defined in /test/support/pages.
#
class ListAndMakeReservationsTest < Capybara::Rails::TestCase

  test "/reservations displays reservation form and an empty list of upcoming reservations" do
    reservations_page = ReservationsPage.new
    reservations_page.load

    assert reservations_page.has_text?("No reservations have been booked.")
    assert reservations_page.has_reservation_list?
    assert reservations_page.reservation_rows.none?
  end


  test "if there are open tables, submitting a valid reservation adds it to the reservation list" do
    reservations_page = ReservationsPage.new
    reservations_page.load
    datetime = Time.zone.now.beginning_of_hour + 1.week

    reservations_page.form.make_reservation!(
      I18n.l(datetime , format: :day_date_time),
      '6',
      'Hakeem',
      'Olajuwon',
      '(773) 555-1234',
      'hakeem@rockets.com'
    )

    assert reservations_page.has_text?(
      "Your reservation for a party of 6 on \
      #{I18n.l(datetime , format: :day_date_time)} has been confirmed."
    )
    assert_equal 1, reservations_page.reservation_rows.count
    assert_equal [I18n.l(datetime , format: :day_date_time).squish,
                  '6',
                  'Hakeem',
                  'Olajuwon',
                  '(773) 555-1234',
                  'hakeem@rockets.com'], reservations_page.row_contents_at(0)
  end


  test "submitting an invalid reservation info displays validation errors" do
    reservations_page = ReservationsPage.new
    reservations_page.load
    datetime = Time.zone.now.beginning_of_hour + 1.week

    reservations_page.form.make_reservation!('', '', '', '', '', '')

    assert reservations_page.has_text?('Please correct the following problems:')
    assert reservations_page.has_no_text?('has been confirmed')
    assert reservations_page.has_text?("No reservations have been booked.")
    assert reservations_page.reservation_rows.none?
  end


  test "submitting multiple valid reservations adds them to the the reservation list" do
    reservations_page = ReservationsPage.new
    reservations_page.load
    datetime = Time.zone.now.beginning_of_hour

    reservations_page.form.make_reservation!(
      I18n.l(datetime + 48.hours, format: :day_date_time),
      '4',
      'Hakeem',
      'Olajuwon',
      '773-555-1234',
      'hakeem@rockets.com'
    )
    reservations_page.form.make_reservation!(
      I18n.l(datetime + 1.week, format: :day_date_time),
      '2',
      'Kevin',
      'McHale',
      '617-888-5678',
      'kevin@celtics.com'
    )
    reservations_page.form.make_reservation!(
      I18n.l(datetime + 60.hours, format: :day_date_time ),
      '6',
      'Gregg',
      'Popovich',
      '210-707-5555',
      'gregg@spurs.com'
    )
    reservations_page.form.make_reservation!(
      I18n.l(datetime + 24.hours, format: :day_date_time ),
      '8',
      'Artis',
      'Gilmore',
      '312-555-8888',
      'artis@spurs.com'
    )

    assert_equal 4, reservations_page.reservation_rows.count
    assert_equal [I18n.l(datetime + 48.hours, format: :day_date_time).squish,
                  '4',
                  'Hakeem',
                  'Olajuwon',
                  '(773) 555-1234',
                  'hakeem@rockets.com'], reservations_page.row_contents_at(1)
    assert_equal [I18n.l(datetime + 1.week, format: :day_date_time).squish,
                  '2',
                  'Kevin',
                  'McHale',
                  '(617) 888-5678',
                  'kevin@celtics.com'], reservations_page.row_contents_at(3)
    assert_equal [I18n.l(datetime + 60.hours, format: :day_date_time).squish,
                  '6',
                  'Gregg',
                  'Popovich',
                  '(210) 707-5555',
                  'gregg@spurs.com'], reservations_page.row_contents_at(2)
    assert_equal [I18n.l(datetime + 24.hours, format: :day_date_time).squish,
                  '8',
                  'Artis',
                  'Gilmore',
                  '(312) 555-8888',
                  'artis@spurs.com'], reservations_page.row_contents_at(0)
  end



  test "when all tables are booked, submitting a valid reservation displays alert message" do
    reservations_page = ReservationsPage.new
    reservations_page.load
    datetime = Time.zone.now.beginning_of_hour + 1.week

    4.times do
      reservations_page.form.make_reservation!(
        I18n.l(datetime , format: :day_date_time),
        '6',
        'Hakeem',
        'Olajuwon',
        '773-555-1234',
        'hakeem@rockets.com'
      )
    end

    assert_equal 4, reservations_page.reservation_rows.count

    reservations_page.form.make_reservation!(
      I18n.l(datetime , format: :day_date_time),
      '8',
      'David',
      'Robinson',
      '210-555-1234',
      'david@spurs.com'
    )

    assert_equal 4, reservations_page.reservation_rows.count
    assert reservations_page.has_text?(
      "No tables that can seat a party of 8 are available"
    )
    assert reservations_page.has_no_text?('has been confirmed')
  end

end
