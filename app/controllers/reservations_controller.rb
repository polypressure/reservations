class ReservationsController < ApplicationController

  #
  # Display a list of upcoming reservations and a form
  # to make a new reservation.
  #
  def index
    render_reservation_list
  end

  #
  # Book a reservation.
  #
  # This uses https://github.com/polypressure/outbacker to
  # eliminate conditional logic in the controllers. All
  # business logic is contained in app/domain/reservation_book.rb,
  # so the controller never interacts directly with models.
  #
  def create
    reservation_book.make_reservation(populated_form) do |on_outcome|

      on_outcome.of(:successful_booking) do |reservation|
        redirect_to reservations_path, notice: success_message(reservation)
      end

      on_outcome.of(:no_availability) do |reservation_form|
        flash.now.alert = no_availability_message(reservation_form)
        render_reservation_list(reservation_form)
      end

      on_outcome.of(:failed_validation) do |reservation_form|
        render_reservation_list(reservation_form)
      end

    end
  end


  #
  # Inject a reservation_book, mainly to support testing:
  #
  def inject_reservation_book(reservation_book)
    @reservation_book = reservation_book
  end


  private

  def render_reservation_list(reservation_form = ReservationForm.new)
    @reservation_form = reservation_form.reformatted!
    @reservations = reservation_book.upcoming_reservations
    render :index
  end

  def reservation_book
    @reservation_book ||= ReservationBook.new
  end

  def populated_form
    ReservationForm.new(reservation_params)
  end

  def reservation_params
    params.require(:reservation_form).permit(:datetime,
                                             :party_size,
                                             :first_name,
                                             :last_name,
                                             :phone,
                                             :email)
  end

  def success_message(reservation)
    "Your reservation for a party of #{reservation.party_size} on \
    #{formatted_time(reservation)} has been confirmed."
  end

  def no_availability_message(reservation_form)
    "No tables that can seat a party of #{reservation_form.party_size} \
    are available on #{formatted_time(reservation_form)}."
  end

  def formatted_time(reservation)
    I18n.l(reservation.datetime, format: :day_date_time)
  end
end
