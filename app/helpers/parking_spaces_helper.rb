module ParkingSpacesHelper
  def status_badge_class(status)
    case status
    when 'available'  then 'bg-blue-50 text-blue-700 border-blue-200'
    when 'contracted' then 'bg-green-50 text-green-700 border-green-200'
    when 'pending'    then 'bg-yellow-50 text-yellow-700 border-yellow-200'
    when 'prohibited' then 'bg-red-50 text-red-700 border-red-200'
    else 'bg-gray-50 text-gray-700 border-gray-200'
    end
  end
end
