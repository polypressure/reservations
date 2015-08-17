require 'test_helper'

#
# As much as possible, I try to test controllers in isolation. Since
# the business logic is all located within the ReservationBook
# domain object (and all persistence logic is behind that facade),
# we controller never interacts directly with ActiveRecord models,
# and it's easy to stub PORO domain objects to support isolated testing.
# I don't bother with mocks and verifying expectations, which are
# brittle and don't add much verification value in controller tests.
#
# Since we're striving for isolated tests, I also don't bother with making
# assertions against HTML content. If we did that, we're basically
# doing an integration test. In fact, I've disabled rendering of
# views within controller tests...see the test_helper.rb, for how this
# has been done. We depend on separate view tests to verify the views,
# as well as the feature/acceptance tests.
#
# Also, I don't strictly adhere to the single-assertion-per-test rule
# here for the sake of simplicity and faster tests. However, I do
# typically try to follow the guideline of testing a single *concept*
# per test. Having separate tests for the HTTP response, the template
# rendered, any assigns or redirects, etc. feels cargo-cultish.
#
class ReservationsControllerTest < ActionController::TestCase

  test "get index" do
    reservations = stubbed_reservations
    stub_reservation_book!(upcoming_reservations: reservations)

    get :index

    assert_response :success
    assert_template :index
    assert_equal reservations, assigns(:reservations)
    assert_not_nil assigns(:reservation_form)
  end


  test "post create with valid parameters and availability" do
    reservations = stubbed_reservations
    stub_reservation_book!(
      method: 'make_reservation',
      outcome: :successful_booking,
      form: stubbed_form_object,
      upcoming_reservations: reservations
    )

    post :create, { reservation_form: stubbed_form_object.to_params }

    assert_redirected_to reservations_url
    assert_flash type: :notice, message: 'has been confirmed'
  end


  test "post create with valid parameters and no availability" do
    reservations = stubbed_reservations
    stub_reservation_book!(
      method: 'make_reservation',
      outcome: :no_availability,
      form: stubbed_form_object,
      upcoming_reservations: reservations
    )

    post :create, { reservation_form: stubbed_form_object.to_params }

    assert_response :success
    assert_template :index
    assert_equal reservations, assigns(:reservations)
    assert_not_nil assigns(:reservation_form)
    assert_flash type: :alert, message: 'No tables.+are available'
  end


  test "post create with invalid parameters" do
    reservations = stubbed_reservations
    stub_reservation_book!(
      method: 'make_reservation',
      outcome: :failed_validation,
      form: stubbed_form_object(valid: false),
      upcoming_reservations: reservations
    )

    post :create, { reservation_form: stubbed_form_object.to_params }

    assert_response :success
    assert_template :index
    assert_equal reservations, assigns(:reservations)
    assert_not_nil assigns(:reservation_form)
  end


  private

  def stubbed_reservations
    [ stubbed_reservation, stubbed_reservation, stubbed_reservation ]
  end

  def stubbed_reservation
    stubbed_customer = stub(
      first_name: 'John',
      last_name: 'Doe',
      phone: '312-555-1212',
      email: 'john@test.com',
    )
    stubbed_reservation = stub(
      datetime: Time.zone.now,
      party_size: 5,
      customer: stubbed_customer
    )
  end

  #
  # To test strictly in isolation, I'd usually stub the form object,
  # but since form objects are so simple, I don't bother. Using actual
  # form objects keeps these tests simpler and avoids minimizes
  # the need for stubbing.
  #
  def stubbed_form_object(valid: true)
    form = ReservationForm.new(
      valid ?
        {
          "datetime"=>"Aug 31, 2015 7:00 pm",
          "party_size"=>"8",
          "first_name"=>"Fred",
          "last_name"=>"Flintstone",
          "phone"=>"213-321-1111",
          "email"=>"fred@flintstone.com"
        } :
        {}
      )
    form.validate
    form
  end

  #
  # Stub the ReservationBook domain object, and inject it
  # into the controller under test. This uses the special
  # stub utility class provided by the Outbacker gem to
  # stub outcomes and the invocation of outcome callbacks.
  #
  def stub_reservation_book!(method: nil,
                             outcome: nil,
                             form: nil,
                             upcoming_reservations: nil)
    reservation_book = Outbacker::OutbackerStub.new
    reservation_book.stub_outbacked_method(method, outcome, form) if method
    reservation_book.stubs(:upcoming_reservations).returns(upcoming_reservations || [])

    @controller.inject_reservation_book(reservation_book)
  end



end
