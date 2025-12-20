class ContractorsController < ApplicationController
  before_action :authenticate_parking_manager!
  before_action :set_contractor, only: %i[show edit update destroy]
  before_action :authorize_contract, only: %i[show edit update destroy]
  before_action :set_available_spaces, only: %i[new edit]

  def new
    @contractor = Contractor.new
  end

  def create
    @contractor = current_parking_manager.contractor.build(contractor_params)
    authorize @contractor

    if @contractor.save
      redirect_to contractors_path, success: "契約者 #{@contractor.first_name} #{@contractor.last_name} の登録が完了しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @contractor = current_parking_manager.contractors.includes(
      active_contract_parking_spaces: {
        parking_space: :parking_lot
      }
    ).find(@contractor.id)
  end

  def index
    @contractors = current_parking_manager.contractors.includes(
      active_contract_parking_spaces: {
        parking_space: :parking_lot
      }
    ).order(created_at: :desc)
  end

  def edit; end

  def update
    update_params = contractor_params
    requested_parking_space_id = update_params[:new_parking_space_id]
    new_start_date = update_params[:start_date].presence || Date.current
    begin

      ActiveRecord::Base.transaction do
        if @contractor.update!(update_params.except(:new_parking_space_id, :start_date, :should_end_all_contracts))
          # 既存の契約を終了する場合
          if should_end_all_contract
            puts "ここまで処理されています"
            # 契約者が持つすべての有効な契約を取得
            @contractor.active_contract_parking_spaces.each do |contract|
              contract.update!(end_date: Date.yesterday)
            end
          end
          # 新しい契約を作成
          if requested_parking_space_id.present?
            ContractParkingSpace.create!(
              parking_space_id: update_params[:new_parking_space_id],
              contractor_id: @contractor.id,
              parking_manager_id: current_parking_manager.id,
              start_date: new_start_date,
              end_date: ::ACTIVE_CONTRACT_END_DATE
            )
          end
        end
      end

      redirect_to @contractor, success: "契約者 #{@contractor.first_name} #{@contractor.last_name} の情報・駐車場登録・更新が完了しました"

    rescue ActiveRecord::RecordInvalid => e
      available_spaces

      @contractor.errors.merge!(e.record.errors) unless @contractor.errors.present?
      flash.now[:alert] = "契約の更新中に予期せぬエラーが発生しました
: #{e.message}"
      render :edit, status: :unprocessable_entity
    rescue StandardError => e
      available_spaces

      flash.now[:alert] = "契約の更新中に予期せぬエラーが発生しました: #{e.message}"
      render :edit, status: :unprocessable_entity
    end
  end


  def destroy
    begin

      @contractor.destroy!
      flash[:success] = "登録された契約者 #{@contractor.first_name} #{@contractor.last_name} が削除されました"
      redirect_to contractors_path, status: :see_other

    rescue ActiveRecord::DeleteRestrictionError => e
      # 関連レコードが存在するため削除できない場合の処理
      flash[:alert] = "契約者は、関連する契約が存在するため削除できません。"
      redirect_to @contractor, status: :see_other # 契約者の詳細ページに戻す

    rescue StandardError => e
      # その他の予期せぬシステムエラーの処理
      flash[:alert] = "契約者の削除中に予期せぬエラーが発生しました: #{e.message}"
      redirect_to @contractor, status: :see_other
    end
  end

  private

  def contractor_params
    params.require(:contractor).permit(
      :first_name, :last_name, :prefecture, :city, :street_address,
      :building, :phone_number, :contact_number, :notes,
      :new_parking_space_id, :start_date, :should_end_all_contracts
    )
  end

  def set_contractor
    @contractor = current_parking_manager.contractors.find(params[:id])
  end

  def available_spaces
    @available_spaces = current_parking_manager.parking_spaces.available.includes(:parking_lot)
  end

  def authorize_contract
    authorize(@contractor)
  end

  # 現在契約している駐車場を終了させる
  def should_end_all_contract
    ActiveModel::Type::Boolean.new.cast(contractor_params[:should_end_all_contracts])
  end

  def set_available_spaces
    active_contract_ids = ContractParkingSpace.where("end_date >= ?", Date.current).pluck(:parking_space_id)
    @available_spaces = current_parking_manager.parking_spaces.where.not(id: active_contract_ids)
  end
end
