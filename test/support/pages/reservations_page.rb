class ReservationsPage < SitePrism::Page
  set_url "/reservations"

  section :form, "form#new_reservation_form" do
    fields :datetime, :party_size, :first_name, :last_name, :phone, :email
    submit_button

    submission :make_reservation

    element :validation_errors, "#error_explanation"
  end

  section :reservation_list, "table#reservation-list" do
    sections :reservations, "tr.reservation" do
      element :datetime, "td.datetime"
      element :party_size, "td.party_size"
      element :first_name, "td.first_name"
      element :last_name, "td.last_name"
      element :phone, "td.phone"
      element :email, "td.email"
    end
  end

  def reservation_rows
    reservation_list.reservations
  end

  def row_contents_at(index)
    row = reservation_list.reservations[index]
    [ row.datetime.text,
      row.party_size.text,
      row.first_name.text,
      row.last_name.text,
      row.phone.text,
      row.email.text ]
  end

end
