class ParkingSpaceBatchForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :parking_area_id, :integer
  attribute :name, :string
  attribute :price, :integer
  attribute :width, :decimal
  attribute :length, :decimal
  attribute :height, :decimal
  attribute :status, :string, default: "available"
  attribute :description, :string
  attribute :batch_count, :integer, default: 1

  validates :name, :parking_area_id, presence: true
  validates :batch_count, presence: true, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 50 }

  def garage_detail_attributes=(attribures)
    extracted_height = attributes[:height] || attributes.dig("0", :heigth)
    if extracted_height.present?
      self.height = extracted_height 
    end
  end

  def save
    return false unless valid?

    parking_area = ParkingArea.find(parking_area_id)
    is_garage = (parking_area.category == "garage")
    base_number = name.to_i
    original_length = name.length

    ActiveRecord::Base.transaction do
      batch_count.times do |i|
        if base_number > 0
          current_number = base_number + i
          current_name = current_number.to_s.rjust(original_length, '0')
        else
          current_name = base_namber > 1 ? "#{name}-#{i + 1}" : name
        end

        space = ParkingSpace.create!(
          parking_area_id: parking_area_id,
          name: current_name,
          price: price,
          width: width,
          length: length,
          status: status,
          description: description,
        )
        if height.present?
          space.build_garage_detail(height: height)
        end

        space.save!
      end
    end
    true

  rescue => e
    if e.message.include?("Name")
      errors.add(name, ":この番号、または名前はすでに使用されています。")
    else
      errors.add(:base, "登録できませんでした。入力を確認してください。")
    end
    false
  end
end
