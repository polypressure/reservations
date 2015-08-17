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
class Table < ActiveRecord::Base

  validates :seats, presence: true, numericality: true

  has_many :reservations
  has_many :customers, through: :reservations

  #
  # Return the tables that can accommodate the party size specified
  # in the "party_size" argument. This ignores whether or not
  # the table has already been reserved.
  #
  scope :seating_at_least, ->(party_size) { where('seats >= ?', party_size) }

  #
  # Return the tables that can accommodate the party size specified
  # in the "for_party_of" argument, on the datetime given in the "on"
  # argument.
  #
  # Reservations, customer and table info are split into separate tables,
  # so this query is expressed naturally as a correlated-not-exists subquery
  # between the tables and reservations tables.
  #
  # Whether this is less performant than a standard outer join with
  # NULL test is DBMS-dependent.
  #
  # Neither of these can really be expressed idiomatically with
  # ActiveRecord/AREL, so this scope is mostly a wrapper for straight SQL.
  #
  scope :open, ->(for_party_of:, on:) {
    where("tables.seats >= ? and \
           not exists (select * from reservations \
                       where reservations.table_id = tables.id and \
                       reservations.datetime = ?)", for_party_of, on)
  }

end
