class ParkingSpace < ApplicationRecord
  include Searchable

  after_initialize :set_default_values

  validates :name, presence: true, uniqueness: { scope: :parking_area_id, message: "はこの駐車場内ですでに使用されています" }, length: { maximum: 10 }
  validates :description, length: { maximum: 150 }
  validates :width, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 9.9 }
  validates :length, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 9.9 }
  validates :parking_area, presence: true
  validates :price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  validate :name_id_immutable_if_contracted, on: :update

  enum :status, { available: 0, contracted: 1, pending: 2, prohibited: 3 }, prefix: true, default: :available

  # 駐車スペースの契約状態スペースを消そうとする時に、契約データがあった場合、エラーで処理を阻止
  has_many :contract_parking_spaces, dependent: :restrict_with_exception
  has_many :active_contractor_parking_spaces, -> { where("end_date >= ?", Date.current) }, class_name: "ContractParkingSpace"
  has_many :contractors, through: :contract_parking_spaces
  has_many :parking_space_option_assignments, dependent: :destroy
  has_many :parking_space_options, through: :parking_space_option_assignments

  belongs_to :parking_area

  has_one :parking_lot, through: :parking_area
  has_one :parking_manager, through: :parking_lot
  has_one :garage_detail, dependent: :destroy

  # 現在の契約者情報を取得
  has_one :current_contract, -> {
    where("start_date <= ? AND end_date >= ?", Date.current, Date.current).order(start_date: :desc)
  }, class_name: "ContractParkingSpace"

  accepts_nested_attributes_for :garage_detail, reject_if: :not_a_garage?, allow_destroy: :true

  delegate :parking_lot, to: :parking_area
  # 駐車エリアからカテゴリーを取得
  delegate :category, to: :parking_area, allow_nil: true

  before_validation :set_default_price, on: :create

  # 駐車スペースの取得（すでに契約されているスペースは排除）
  scope :available, -> {
  # 有効な契約を持つIDを抽出
  occupied_ids = ContractParkingSpace.active.select(:parking_space_id)
  # そのIDに含まれないものを「空き」とする
  where.not(id: occupied_ids)
  }

  scope :contracted, -> {
    joins(:contract_parking_spaces).
    where("contract_parking_spaces.start_date <= :today AND (contract_parking_spaces.end_date >= :today OR contract_parking_spaces.end_date IS NULL)", today: Date.current)
    .distinct
  }

  def self.total_revenue
    contracted.sum(:price)
  end

  # 自然順ソート
  def self.sort_by_natural_name
    all.to_a.sort_by do |record|
      record.name.scan(/\d+|\D+/).map do |fragment|
        if fragment =~ /\A\d+\z/
          [ 0, fragment.to_i ]
        else
          [ 1, fragment.to_s ]
        end
      end
    end
  end

  def current_contractor_id
    current_contractors_space&.contractor_id
  end

  # ガレージを選択したか確認
  def not_a_garage?(attributes)
    parking_area&.category != "garage"
  end

  # 契約終了日が今日以降、または無期限の契約か確認
  def currently_contracted?
    contract_parking_spaces.where("end_date >= ?", Date.today).exists?
  end

  # 料金設定：個別設定がなければエリアの基本料金
  def current_price
    price > 0 ? price: parking_area.default_price
  end

  def self.searchable_config
    {
      against: { name: "A", description: "B" },
      associated_against: { contractors: [ :first_name, :last_name ] },
      using: { tsearch: { any_word: true } }
    }
  end
  configure_search

  private

  def set_default_values
    if new_record?
      self.width ||= 0.0
      self.length ||= 0.0
    end
  end

  def name_id_immutable_if_contracted
    if name_changed? && contract_parking_spaces.exists?
      errors.add(:name, "は契約実績があるため変更できません。")
    end
  end

  # 価格設定していない場合、エリアの価格をコピー
  def set_default_price
    if price.to_i == 0 && parking_area.present?
      self.price = parking_area&.default_price
    end
  end
end
