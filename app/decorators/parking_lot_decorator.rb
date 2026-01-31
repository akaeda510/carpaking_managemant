class ParkingLotDecorator < Draper::Decorator
  delegate_all

  def address
    object.contact_number.to_s.gsub(/(\d{2,4})(\d{2,4})(\d{4})/,     '\1-\2-\3')
  end
end
