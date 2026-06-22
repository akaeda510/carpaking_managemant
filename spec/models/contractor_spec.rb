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

      it 'phone_numberが11文字数以外だった場合' do

      end

      it 'phone_numberが数字以外だった場合' do

      end

      it 'phone_numberが空欄だった場合' do
        
      end

      it 'phone_numberが他のユーザーと重複した場合' do

      end

      it 'contact_numberが10文字以上11文字以内でなかった場合' do

      end

      it 'contact_numberが数字以外だった場合' do

      end

      it 'notesが151文字以上だった場合' do

      end
    end
  end
end
