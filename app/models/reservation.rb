#
# Since business logic is kept strictly in PORO domain objects
# (in this app, the ReservationBook object), and validation/parsing
# logic is kept strictly in form objects (in this app, ReservationForm),
# models are focused strictly on persistence and database queries.
#
# This keeps models and their tests lean and focused. Lean,
# focused model tests are particularly important, as model
# tests can involve a lot of data setup.
#
class Reservation < ActiveRecord::Base

  scope :in_future, -> { where('datetime > ?', Time.zone.now) }
  scope :by_datetime, -> { order('datetime') }
  scope :upcoming, -> { includes(:customer, :table).in_future.by_datetime }

  belongs_to :table
  belongs_to :customer

end
