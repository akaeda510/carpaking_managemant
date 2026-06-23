require 'rails_helper'

RSpec.describe ParkingLot, type: :model do
  describe 'create' do
    let(:parking_manager) { FactoryBot.create(:parking_manager) }
    let(:parking_lot) { FactoryBot.build(:parking_lot) }
    
    # 成功パターン
    context 'バリデーション' do 
      it '設定した全てのバリデーションが機能しているか' do
        expect(parking_lot).to be_valid
      end
    end

    # 失敗パターン
    context 'バリデーション' do
      it 'nameが41文字以上だった場合' do
        parking_lot.name = 'あ' * 41
        expect(parking_lot).to be_invalid
      end

      it 'nameが空欄だった場合' do
        parking_lot.name = nil
        expect(parking_lot).to be_invalid
      end

      it 'prefectureが選択されていない場合' do 
        parking_lot.prefecture = nil
        expect(parking_lot).to be_invalid
        expect(parking_lot.errors[:prefecture]).to contain_exactly("を正しく選択してください")
      end

      it 'cityが21文字以上の場合' do
        parking_lot.city = 'あ' * 21
        expect(parking_lot).to be_invalid
      end

      it 'cityが空欄の場合' do
        parking_lot.city = nil
        expect(parking_lot).to be_invalid
      end

      it 'street_addressが51文字以上の場合' do
        parking_lot.street_address = 'あ' * 51
        expect(parking_lot).to be_invalid
      end

      it 'street_addressが空欄の場合' do
        parking_lot.street_address = nil
        expect(parking_lot).to be_invalid
      end

      it 'descriptionが151文字以上だった場合' do
        parking_lot.description = 'あ' * 151
        expect(parking_lot).to be_invalid
      end

      it 'total_specesが100以上だった場合' do
        parking_lot.total_spaces = '100'
        expect(parking_lot).to be_invalid
      end

      it 'total_spacesが数字以外だった場合' do
        parking_lot.total_spaces = 'あ'
        expect(parking_lot).to be_invalid
      end

      it 'total_spacesが0だった場合' do
      end

      it 'total_spacesが空欄だった場合' do 
      end
    end
  end
end
