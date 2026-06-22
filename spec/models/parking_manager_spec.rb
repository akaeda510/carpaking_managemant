require 'rails_helper'

RSpec.describe ParkingManager, type: :model do
  # 成功パターン
  describe 'create' do
    let(:parking_manager) { FactoryBot.build(:parking_manager) }
    context 'バリデーションチェック' do
      it '設定した全てのバリデーションが機能しているか' do
        expect(parking_manager).to be_valid
      end
    end

    # 失敗パターン
    context 'バリデーション失敗' do
      it 'first_nameが21文字以上の場合' do 
        parking_manager.first_name = 'あ' * 21
        expect(parking_manager).to be_invalid
      end

      it 'first_nameが空欄の場合' do 
        parking_manager.first_name = nil
        expect(parking_manager).to be_invalid
      end

      it 'last_nameが21文字以上の場合' do 
        parking_manager.last_name = 'あ' * 21
        expect(parking_manager).to be_invalid
      end

      it 'last_nameが空欄の場合' do 
        parking_manager.last_name = nil
        expect(parking_manager).to be_invalid
      end

      it 'emailが51文字以上だった場合' do 
        parking_manager.email = 'あ' * 51
        expect(parking_manager).to be_invalid
      end

      it 'emailが空欄だった場合' do 
        parking_manager.email = nil
        expect(parking_manager).to be_invalid
      end

      it 'emailが既に登録されている場合' do
        parking_manager = create(:parking_manager, email: 'user@email.com')
        parking_manager_1 = build(:parking_manager, email: 'user@email.com')
        expect(parking_manager_1).to be_invalid
      end

      it 'prefectureが選択されていない場合' do
        parking_manager.prefecture = nil
        expect(parking_manager).to be_invalid
        expect(parking_manager.errors[:prefecture]).to contain_exactly("を正しく選択してください")
      end

      it 'cityが21文字以上の場合' do 
        parking_manager.city = 'あ' * 21
        expect(parking_manager).to be_invalid
      end

      it 'cityが空欄の場合' do 
        parking_manager.city = nil
        expect(parking_manager).to be_invalid
      end

      it 'street_addressが51文字以上の場合' do
        parking_manager.street_address = 'あ' * 51
        expect(parking_manager).to be_invalid
      end

      it 'street_addressが空欄の場合' do 
        parking_manager.street_address = nil
        expect(parking_manager).to be_invalid
      end

      it 'buildingが56文字以上の場合' do 
        parking_manager.building = 'あ' * 56
        expect(parking_manager).to be_invalid
      end

      it 'phone_numberが11文字数以外だった場合' do 
        parking_manager.phone_number = '1' * 10
        expect(parking_manager).to be_invalid

        parking_manager.phone_number = '1' * 12
        expect(parking_manager).to be_invalid
      end

      it 'phone_numberが数字以外だった場合' do 
        parking_manager.phone_number = 'あいうえお。、＠％＆＊！'
        expect(parking_manager).to be_invalid
      end

      it 'phone_numberが空欄だった場合' do 
        parking_manager.phone_number = nil
        expect(parking_manager).to be_invalid
      end

      it 'phone_numberが他のユーザーと重複した場合' do 
      parking_manager = create(:parking_manager, phone_number: '09012341234')
      parking_manager_1 = build(:parking_manager, phone_number: '09012341234')
      expect(parking_manager_1).to be_invalid
      end

      it 'contact_numberが10文字以上11文字以内でなかった場合' do 
        parking_manager.contact_number = '1' * 9
        expect(parking_manager).to be_invalid

        parking_manager.contact_number = '1' * 12
        expect(parking_manager).to be_invalid
      end

      it 'contact_numberが数字以外だった場合' do
        parking_manager.contact_number = 'あいうえお。、＠％-＆＊！'
        expect(parking_manager).to be_invalid
      end

      it '利用規約の同意がチェックされていなかった場合' do
        parking_manager.terms_of_service = false
        expect(parking_manager).to be_invalid
        expect(parking_manager.errors[:terms_of_service]).to contain_exactly("に同意してください")
      end
    end
  end
end
