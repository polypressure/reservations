#
# Form object to collect input for reservations and customers,
# which is split in the database between the Reservation and
# Customer models. This avoids having to use things like
# accepts_nested_attributes_for, while keeping our input
# parsing, validation, and formatting rules separate from
# the models, helping to keep models and their tests lean
# and focused on persistence, queries, etc.
#
# See https://github.com/polypressure/formant for more details.
#
class ReservationForm < Formant::FormObject

  #
  # All the form fields, containing attributes from both
  # the Reservation and Customer models:
  #
  attr_accessor(
    :datetime,
    :party_size,
    :first_name, :last_name,
    :phone, :email
  )

  #
  # Rules for any special parsing/transformation upon input.
  #
  parse :datetime, as: :datetime
  parse :phone, as: :phone_number
  parse :first_name, to: :strip_whitespace, squish: true
  parse :last_name, to: :strip_whitespace, squish: true
  parse :email, to: :strip_whitespace

  #
  # Validation rules, as usual:
  #
  validates :datetime, presence: true
  validate :in_future

  validates :party_size, presence: true, numericality: true
  validate :party_size_at_least_one

  validates :first_name, presence: true
  validates :last_name, presence: true

  validates_plausible_phone :phone, presence: true
  validates :email, presence: true, email: true

  def party_size_at_least_one
    if party_size.to_i < 1
      errors.add(:party_size, "must be at least 1")
    end
  end

  def in_future
    errors.add(:datetime, "must be in the future") if datetime && datetime.past?
  end

  #
  # Rules for any special formatting/transformation upon output
  # or redisplay of the form.
  #
  reformat :datetime, as: :datetime, format: :day_date_time
  reformat :phone, as: :phone_number, country_code: 'US'



end
