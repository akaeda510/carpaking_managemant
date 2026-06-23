require 'rails_helper'

RSpec.describe Contractor, type: :model do
  describe 'create' do
    let(:contractor) { FactoryBot.build(:contractor) }
    let(:parking_manager) { FactoryBot.create(:parking_manager) }

    # 成功パターン
    context 'バリデーション' do
      it '設定した全てのバリデーションが機能しているか' do
        expect(contractor).to be_valid
      end

      it '別の管理者が同じphone_numberを登録する時' do
        parking_manager_1 = create(:parking_manager)
        parking_manager_2 = create(:parking_manager)
        contractor = create(:contractor, parking_manager: parking_manager_1, phone_number: '09012341234')
        contractor_1 = create(:contractor, parking_manager: parking_manager_2, phone_number: '09012341234')

        expect(contractor_1).to be_valid
      end

      it 'first_nameが20文字だった場合' do
        contractor.first_name = 'あ' * 20
        expect(contractor).to be_valid
      end

      it 'last_nameが20文字だった場合' do
        contractor.last_name = 'あ' * 20
        expect(contractor).to be_valid
      end

      it 'cityが20文字だった場合' do
        contractor.city = 'あ' * 20
        expect(contractor).to be_valid
      end

      it 'street_addressが50文字だった場合' do
        contractor.street_address = 'あ' * 50
        expect(contractor).to be_valid
      end

      it 'buildingが55文字だった場合' do
        contractor.building = 'あ' * 55
        expect(contractor).to be_valid
      end

      it 'phone_numberが11文字だった場合' do
        contractor.phone_number = '1' * 11
        expect(contractor).to be_valid
      end

      it 'contact_numberが10文字だった場合' do
      end

      it 'contact_numberが11文字だった場合' do
      end

      it 'notesが150文字だった場合' do
      end
    end

    # 失敗パターン
    context 'バリデーション' do
      it 'first_nameが21文字以上の場合' do
        contractor.first_name = 'あ' * 21
        expect(contractor).to be_invalid
      end

      it 'first_nameが空欄の場合' do
        contractor.first_name = nil
        expect(contractor).to be_invalid
      end

      it 'last_nameが21文字以上の場合' do
        contractor.last_name = 'あ' * 21
        expect(contractor).to be_invalid
      end

      it 'last_nameが空欄の場合' do
        contractor.last_name = nil
        expect(contractor).to be_invalid
      end

      it 'prefectureが選択されていない場合' do
        contractor.prefecture = nil
        expect(contractor).to be_invalid
        expect(contractor.errors[:prefecture]).to contain_exactly("を正しく選択してください")
      end

      it 'cityが21文字以上の場合' do
        contractor.city = 'あ' * 21
        expect(contractor).to be_invalid
      end

      it 'cityが空欄の場合' do
        contractor.city = nil
        expect(contractor).to be_invalid
      end

      it 'street_addressが51文字以上の場合' do
        contractor.street_address = 'あ' * 51
        expect(contractor).to be_invalid
      end

      it 'street_addressが空欄の場合' do
        contractor.street_address = nil
        expect(contractor).to be_invalid
      end

      it 'buildingが56文字以上の場合' do
        contractor.building = 'あ' * 56
        expect(contractor).to be_invalid
      end

      it 'phone_numberが10文字の場合' do
        contractor.phone_number = '1' * 10
        expect(contractor).to be_invalid
      end

      it 'phone_numberが12文字の場合' do
        contractor.phone_number = '1' * 12
        expect(contractor).to be_invalid
      end

      it 'phone_numberが数字以外だった場合' do
        contractor.phone_number = 'あいうえお！＠ー。、1'
        expect(contractor).to be_invalid
      end

      it 'phone_numberが空欄だった場合' do
        contractor.phone_number = nil
        expect(contractor).to be_invalid
      end

      it '同じ管理者でphone_numberが他のユーザーと重複した場合' do
        parking_manager = create(:parking_manager)
        contractor = create(:contractor, parking_manager: parking_manager, phone_number: '09012341234')
        contractor_1 = build(:contractor, parking_manager: parking_manager, phone_number: '09012341234')
        expect(contractor_1).to be_invalid
      end

      it 'contact_numberが9文字だった場合' do
        contractor.contact_number = '1' * 9
        expect(contractor).to be_invalid
      end

      it 'contact_numberが12文字だった場合' do
        contractor.contact_number = '1' * 12
        expect(contractor).to be_invalid
      end

      it 'contact_numberが数字以外だった場合' do
        contractor.contact_number = 'あいうえお！＠ー。、1'
        expect(contractor).to be_invalid
      end

      it 'notesが151文字以上だった場合' do
        contractor.notes = 'あ' * 151
        expect(contractor).to be_invalid
      end

      it 'parking_managerが紐づいていない場合' do
        contractor.parking_manager = nil
        expect(contractor).to be_invalid
      end
    end
  end

  describe 'アソシエーション' do
    it '契約履歴がある場合、削除されない' do
    end
  end
end
