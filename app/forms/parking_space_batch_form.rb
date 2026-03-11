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
  attribute :parking_space_option_ids, default: []
  attribute :garage_detail_attributes, default: {}

  validates :name, :parking_area_id, presence: true
  validates :batch_count, presence: true, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 50 }
  validates :height, presence: true, if: -> { ParkingArea.find_by(id: parking_area_id)&.category == "garage" }

  def garage_detail_attributes=(attributes)
    extracted_height = attributes[:height] || attributes.dig("0", :height)
    if extracted_height.present?
      self.height = extracted_height
    end
  end

  def save
    self.name = name.tr("０-９ａ-ｚＡ-Ｚ－", "0-9a-zA-Z-") if name.present?

    return false unless valid?

    parking_area = ParkingArea.find(parking_area_id)
    is_garage = (parking_area.category == "garage")

    ActiveRecord::Base.transaction do
      generate_names.each do |target_name|
        space_params = {
          parking_area_id: parking_area_id,
          name: target_name,
          price: price,
          width: width,
          length: length,
          status: status,
          description: description,
          parking_space_option_ids: parking_space_option_ids
        }

      if is_garage && height.present?
        space_params[:garage_detail_attributes] = { height: height }
      end
      parking_area.parking_spaces.create!(space_params)
      end
    end
    true

  rescue => e
    if e.message.include?("Name")
      errors.add(name, ":この番号、または名前はすでに使用されています。: #{e.message}")
    else
      errors.add(:base, "登録できませんでした。入力を確認してください。")
      errors.add(:base, "予期せぬエラーが発生しました: #{e.message}")
    end
    false
  end

  private

  def generate_names
    if name =~ /\A(.*?)(\d+)\z/
      prefix = $1
      start_number = $2.to_i
      digit_length = $2.length
    else
      prefix = name
      start_number = 1
      digit_length = 1
    end

    Array.new(batch_count) do |i|
      current_number = start_number + i
      "#{prefix}#{current_number.to_s.rjust(digit_length, '0')}"
    end
  end
end
