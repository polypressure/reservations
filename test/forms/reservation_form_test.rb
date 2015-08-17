require 'test_helper'

#
# This tests the ReservationForm form object, which
# contains all our input parsing/normalization, validation,
# and formatting logic, separate from the ActiveRecord models,
# and thus has no dependencies that need to be stubbed.
#
# Separating out parsing/normalization/validation logic
# helps us to keep our tests smaller and more focused.
#
class ReservationFormTest < ActiveSupport::TestCase

  test "can initialize form object from params hash" do
    form = ReservationForm.new({
      datetime: 'Aug 26, 2015 7:00 pm',
      party_size: 8,
      first_name: 'John',
      last_name: 'Doe',
      email: 'john@test.com',
      phone: '312-555-1212'
    })

    assert_equal 'Aug 26, 2015 7:00 pm', form.datetime
    assert_equal 8, form.party_size
    assert_equal 'John', form.first_name
    assert_equal 'Doe', form.last_name
    assert_equal 'john@test.com', form.email
    assert_equal '312-555-1212', form.phone
  end


  test "validation succeeds with valid attributes" do
    form = ReservationForm.new({
      datetime: 'Aug 26, 2015 7:00 pm',
      party_size: 8,
      first_name: 'John',
      last_name: 'Doe',
      email: 'john@test.com',
      phone: '312-555-1212'
    })

    assert form.valid?
  end


  test "validation fails with invalid attributes" do
    form = ReservationForm.new({})

    assert form.invalid?
  end


  test "validation fails with missing first name" do
    form = ReservationForm.new({
      datetime: 'Aug 26, 2015 7:00 pm',
      party_size: 8,
      first_name: '',
      last_name: 'Doe',
      email: 'john@test.com',
      phone: '312-555-1212'
    })

    assert form.invalid?
  end


  test "validation fails with missing last name" do
    form = ReservationForm.new({
      datetime: 'Aug 26, 2015 7:00 pm',
      party_size: 8,
      first_name: 'Joe',
      last_name: '',
      email: 'john@test.com',
      phone: '312-555-1212'
    })

    assert form.invalid?
  end


  test "validation fails with missing email" do
    form = ReservationForm.new({
      datetime: 'Aug 26, 2015 7:00 pm',
      party_size: 8,
      first_name: 'Joe',
      last_name: 'Doe',
      email: '',
      phone: '312-555-1212'
    })

    assert form.invalid?
  end


  test "validation fails with missing phone" do
    form = ReservationForm.new({
      datetime: 'Aug 26, 2015 7:00 pm',
      party_size: 8,
      first_name: 'Joe',
      last_name: 'Doe',
      email: 'john@test.com',
      phone: ''
    })

    assert form.invalid?
  end


  test "validation fails with missing party size" do
    form = ReservationForm.new({
      datetime: 'Aug 26, 2015 7:00 pm',
      party_size: '',
      first_name: 'Joe',
      last_name: 'Doe',
      email: 'john@test.com',
      phone: '312-555-1212'
    })

    assert form.invalid?
  end


  test "validation fails with missing datetime" do
    form = ReservationForm.new({
      datetime: '',
      party_size: '8',
      first_name: 'Joe',
      last_name: 'Doe',
      email: 'john@test.com',
      phone: '312-555-1212'
    })

    assert form.invalid?
  end


  test "datetime is parsed into TimeWithZone" do
    form = ReservationForm.new({
      datetime: 'Aug 26, 2015 7:00 pm',
      party_size: '8',
      first_name: 'Joe',
      last_name: 'Doe',
      email: 'john@test.com',
      phone: '312-555-1212'
    })

    form.validate

    assert_equal Time.zone.local(2015, 8, 26, 19, 0), form.datetime
  end


  test "leading/trailing/internal whitespace is stripped and squished from first_name" do
    form = ReservationForm.new({
      datetime: 'Aug 26, 2015 7:00 pm',
      party_size: '8',
      first_name: ' Joe  Bob  ',
      last_name: 'Doe',
      email: 'john@test.com',
      phone: '312-555-1212'
    })

    form.validate

    assert_equal 'Joe Bob', form.first_name
  end


  test "leading/trailing/internal whitespace is stripped and squished from last_name" do
    form = ReservationForm.new({
      datetime: 'Aug 26, 2015 7:00 pm',
      party_size: '8',
      first_name: ' Joe  Bob  ',
      last_name: ' Doe    ',
      email: 'john@test.com',
      phone: '312-555-1212'
    })

    form.validate

    assert_equal 'Doe', form.last_name
  end


  test "leading/trailing whitespace is stripped from email" do
    form = ReservationForm.new({
      datetime: 'Aug 26, 2015 7:00 pm',
      party_size: '8',
      first_name: ' Joe  Bob  ',
      last_name: ' Doe    ',
      email: '  john@test.com  ',
      phone: '312-555-1212'
    })

    form.validate

    assert_equal 'john@test.com', form.email
  end


  test "reformats the phone number" do
    form = ReservationForm.new({
      datetime: 'Aug 26, 2015 7:00 pm',
      party_size: 8,
      first_name: 'John',
      last_name: 'Doe',
      email: 'john@test.com',
      phone: '312.555-1212'
    })

    form.validate
    form.reformatted!

    assert_equal '(312) 555-1212', form.phone
  end


  test "reformats datetime" do
    form = ReservationForm.new({
      datetime: 'Aug 26, 2015 7:00 pm',
      party_size: 8,
      first_name: 'John',
      last_name: 'Doe',
      email: 'john@test.com',
      phone: '312.555-1212'
    })

    form.validate
    form.reformatted!

    assert_equal 'Wed, Aug 26, 7:00 PM', form.datetime
  end


  test "to_params returns a hash of all the attributes" do
    attrs = {
      datetime: 'Aug 26, 2015 7:00 pm',
      party_size: 8,
      first_name: 'John',
      last_name: 'Doe',
      email: 'john@test.com',
      phone: '312-555-1212'
    }

    form = ReservationForm.new(attrs)

    assert_equal attrs, form.to_params
  end

end
