require 'rails_helper'

RSpec.describe ContractParkingSpace, type: :model do
  let(:parking_space) { FactoryBot.create(:parking_space) }
  let(:contractor) { FactoryBot.create(:contractor) }
  let(:contract_parking_space) { FactoryBot.build(:contract_parking_space) }

  describe 'create' do
    # 成功パターン
    context 'バリデーション' do
      it '設定した全てのバリデーションが機能しているか' do
        expect(contract_parking_space).to be_valid
      end

      it 'end_dateが空欄の時、"2999/12/31"になるか' do
        skip "実装予定"
        contract_parking_space.end_date = nil
        expect(contract_parking_space).to eq '2999/12/31'
      end
    end

    # 失敗パターン
    context 'バリデーション' do
      it 'end_dateがstert_dateよりも前だった場合' do
        contract_parking_space = build(:contract_parking_space, start_date: Date.today, end_date: Date.yesterday)
        expect(contract_parking_space).to be_invalid
      end

      it 'contractorが紐づいていない場合' do
        contract_parking_space.contractor = nil
        expect(contract_parking_space).to be_invalid
      end

      it '既にparking_spaceが契約していた場合' do
        contract_parking_space.parking_space = nil
        expect(contract_parking_space).to be_invalid
      end

      it 'parking_spaceが紐づいていない場合' do
      end

      it 'parking_managerが紐づいていない場合' do
      end
    end
  end

  describe 'update' do
    # 成功パターン
    context 'バリデーション' do
      it 'end_dateを今日に設定できるか' do
      end
    end

    # 失敗パターン
    context 'バリデーション' do
      it 'start_dateを変更した場合' do
      end

      it '契約者を変更した場合' do
      end

      it '駐車スペースを変更した場合' do
      end
    end
  end

  describe 'スコープ' do
    describe '.active' do
      it '契約期間内の場合は、含まれる' do
      end

      it '契約期間外（終了済み)の場合は、含まない' do
      end

      it 'end_dateがnilで開始日が過去の場合、含まれる' do
      end
    end

    describe '.terminated' do
      it '終了日が過去の場合は、含まれる' do
      end
    end

    describe '.created_this_month' do
      it '今月作成された場合は、含まれる' do
      end
    end
  end

  describe '#expirigng_soon?' do
    it '終了日が30日以内の場合は、trueを返す' do
    end

    it '終了日が31日以上先の場合、falseを返す' do
    end

    it 'end_dateが"2999/12/31"の場合、falseを返す' do
    end
  end

  describe '#expired' do
    it '終了日が過去の場合、trueを返す' do
    end

    it '終了日が未来の場合、falseを返す' do
    end
  end
end
