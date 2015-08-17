#
# Domain object containing the business logic for listing and
# making reservations.
#
# This is a plain-old Ruby object, which supports and simplifies
# isolated testing. Persistence details are delegated to the
# ActiveRecord models. Since they are free of business logic,
# they can stay lean and focused. Also, since business logic
# often spans multiple ActiveRecord models, a separate object
# often provides a more natural home for it.
#
# The outcome callback approach also keeps conditional logic
# out of controllers (and removes any temptation to leak business
# logic back into the controllers. )
#
# See https://github.com/polypressure/outbacker for more details.
#
class ReservationBook
  include Outbacker

  #
  # Returns a list of upcoming of reservations, (i.e., whose date
  # hasn't already passed), sorted in ascending date order.
  #
  def upcoming_reservations
    Reservation.upcoming
  end

  #
  # Make a reservation given the details in a ReservationForm object.
  # The possible outcomes:
  #  * successful_booking: The reservation was successfuly booked.
  #  * no_availability:    No tables are available for the requested
  #                        date/time and party size.
  #  * failed_validation:  Incomplete/incorrect data was provided in
  #                        the ReservationForm object.
  #
  def make_reservation(reservation_form, &outcome_handlers)
    with outcome_handlers do |outcomes|
      ActiveRecord::Base.transaction do

        if reservation_form.invalid?
          outcomes.handle(:failed_validation, reservation_form) and return
        end

        open_tables = open_tables(for_party_of: reservation_form.party_size,
                                  on: reservation_form.datetime)
        if open_tables.empty?
          outcomes.handle(:no_availability, reservation_form) and return
        end

        reservation = save_reservation!(open_tables.first, reservation_form)
        outcomes.handle :successful_booking, reservation
      end
    end
  end

  #
  # Return the largest table size, regardless of availability.
  #
  def self.max_table_size
    Table.maximum(:seats)
  end


  private

  #
  # Returns a list of tables that can accommodate a party of
  # the size provided in the "for_party_of:" argument, on the
  # datetime provided in the "on:" argument.
  #
  # If no tables are available that can accommodate the party
  # size on the requested date, returns an empty list.
  #
  def open_tables(for_party_of:, on:)
    Table.open(for_party_of: for_party_of, on: on)
  end

  #
  # Create a Reservation record and the associated Customer record
  # given the details in the ReservationForm. The Customer record
  # is only created if one does not already exist for the given
  # name, phone, and email.
  #
  def save_reservation!(table, reservation_form)
    Reservation.create!(datetime: reservation_form.datetime,
                        party_size: reservation_form.party_size,
                        customer: customer_from!(reservation_form),
                        table: table)
  end

  #
  # Find or create a Customer if one does not already exist for
  # the name, phone, and email in the given ReservationForm.
  #
  def customer_from!(reservation_form)
    Customer.find_or_create_by(first_name: reservation_form.first_name,
                               last_name: reservation_form.last_name,
                               phone: reservation_form.phone,
                               email: reservation_form.email)
  end

end
