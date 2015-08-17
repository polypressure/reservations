module ApplicationHelper
  def zurb_class_for(flash_type)
    unless flash_type.respond_to?(:to_sym)
      raise ArgumentError, "Invalid flash type: #{flash_type}"
    end

    case flash_type.to_sym
    when :success, :notice
      'success'
    when :error, :alert
      'alert'
    else
      'warning'
    end
  end

  def party_size_choices
    (1..ReservationBook.max_table_size).map{ |n| [ pluralize(n, 'person'), n ] }
  end

end
