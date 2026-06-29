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
      it '契約終了日が契約開始日よりも前だった場合' do
        skip "未実装"
        contract_parking_space = build(:contract_parking_space, start_date: Date.today, end_date: Date.yesterday)
        expect(contract_parking_space).to be_invalid
      end

      it 'contractorが紐づいていない場合' do
        contract_parking_space.contractor = nil
        expect(contract_parking_space).to be_invalid
      end

      it '既にparking_spaceが契約していた場合' do
        skip "未実装"
        parking_space = create(:parking_space)
        contract_parking_space_1 = create(:contract_parking_space, parking_space: parking_space)
        contract_parking_space_2 = build(:contract_parking_space, parking_space: parking_space)
        expect(contract_parking_space_2).to be_invalid
      end

      it 'parking_spaceが紐づいていない場合' do
        contract_parking_space.parking_space = nil
        expect(contract_parking_space).to be_invalid
      end

      it 'parking_managerが紐づいていない場合' do
        contract_parking_space.parking_manager = nil
        expect(contract_parking_space).to be_invalid
      end
    end
  end

  describe 'update' do
    # 成功パターン
    context 'バリデーション' do
      it 'end_dateを今日に変更できるか' do
        contract_parking_space = create(:contract_parking_space, end_date: 2.months.from_now)
        contract_parking_space.end_date = Date.today
        expect(contract_parking_space).to be_valid
      end
    end

    # 失敗パターン
    context 'バリデーション' do
      context '契約が有効な場合' do
        it 'start_dateを変更した場合' do
          skip "未実装"
          contract_parking_space = create(:contract_parking_space, start_date: 1.month.ago.to_date)
          contract_parking_space.start_date = Date.today
          expect(contract_parking_space).to be_invalid
        end

        it '契約終了が契約開始日よりも後の場合' do
          skip "未実装"
          contract_parking_space = create(:contract_parking_space, start_date: 1.month.ago.to_date)
          contract_parking_space.end_date = 2.months.ago.to_date
          expect(contract_parking_space).to be_invalid
        end

        it '契約者を変更した場合' do
          skip "未実装"
          contractor_1 = create(:contractor)
          contractor_2 = create(:contractor)
          contract_parking_space = create(:contract_parking_space, contractor: contractor_1)

          contract_parking_space.contractor = contractor_2
          expect(contract_parking_space).to be_invalid
        end

        it '駐車スペースを変更した場合' do
          skip "未実装"
          parking_space_1 = create(:parking_space)
          parking_space_2 = create(:parking_space)
          contract_parking_space = create(:contract_parking_space, parking_space: parking_space_1)

          contract_parking_space.parking_space = parking_space_2
          expect(contract_parking_space).to be_invalid
        end
      end
    end
  end

  describe 'スコープ' do
    describe '.active' do
      it '契約期間内の場合は、含まれる' do
        contract_parking_space = create(:contract_parking_space, start_date: 1.month.ago.to_date, end_date: Date.today)
        expect(ContractParkingSpace.active).to include(contract_parking_space)
      end

      it '契約期間外（終了済み)の場合は、含まない' do
        contract_parking_space = create(:contract_parking_space, start_date: 1.month.ago.to_date, end_date: Date.yesterday)
        expect(ContractParkingSpace.active).not_to include(contract_parking_space)
      end

      it 'end_dateがnilで開始日が過去の場合、含まれる' do
        skip "end_dateがnilの場合default設定の未実装ため"
        contract_parking_space = create(:contract_parking_space, start_date: 1.month.ago.to_date, end_date: nil)
        expect(ContractParkingSpace.active).to include(contract_parking_space)
      end
    end

    describe '.terminated' do
      it '終了日が過去の場合は、含まれる' do
        contract_parking_space = create(:contract_parking_space, start_date: 1.month.ago.to_date, end_date: Date.yesterday)
        expect(ContractParkingSpace.terminated).to include(contract_parking_space)
      end
    end

    describe '.created_this_month' do
      it '今月の1日に作成された場合は、含まれる' do
        contract_parking_space = create(:contract_parking_space, created_at: Date.today.at_beginning_of_month)
        expect(ContractParkingSpace.created_this_month).to include(contract_parking_space)
      end

      it '今月の最終日に作成された場合は、含まれる' do
        contract_parking_space = create(:contract_parking_space, created_at: Date.today.at_end_of_month)
        expect(ContractParkingSpace.created_this_month).to include(contract_parking_space)
      end

      it '今月作成されなかった場合は、含まれない' do
        contract_parking_space = create(:contract_parking_space, created_at: 1.month.ago)
        expect(ContractParkingSpace.created_this_month).not_to include(contract_parking_space)
      end
    end
  end

  describe '#expiring_soon?' do
    it '終了日が30日以内の場合は、trueを返す' do
      contract_parking_space = create(:contract_parking_space, end_date: Date.today + 30.days)
      expect(contract_parking_space.expiring_soon?).to be true
    end

    it '終了日が31日以上先の場合、falseを返す' do
contract_parking_space = create(:contract_parking_space, end_date: Date.today + 31.days)
      expect(contract_parking_space.expiring_soon?).to be false
    end

    it 'end_dateが"2999/12/31"の場合、falseを返す' do
 contract_parking_space = create(:contract_parking_space, end_date: "2999/12/31")
      expect(contract_parking_space.expiring_soon?).to be false
  end
  end

  describe '#expired?' do
    it '終了日が過去の場合、trueを返す' do
      contract_parking_space = create(:contract_parking_space, start_date: 1.month.ago, end_date: Date.yesterday)
      expect(contract_parking_space.expired?).to be true
    end

    it '終了日が未来の場合、falseを返す' do
      contract_parking_space = create(:contract_parking_space, end_date: Date.tomorrow)
      expect(contract_parking_space.expired?).to be false
    end
  end
end
