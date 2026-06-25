require 'rails_helper'

RSpec.describe ParkingArea, type: :model do
  describe 'create' do
    let(:parking_lot) { FactoryBot.create(:parking_lot) }
    let(:parking_area) { FactoryBot.build(:parking_area) }

    # 成功パターン
    context 'バリデーション' do
      it '設定した全てのバリデーションが機能しているか' do
        expect(parking_area).to be_valid
      end

      it 'nameが20文字だった場合' do
        parking_area.name = 'あ' * 20
        expect(parking_area).to be_valid
      end

      it 'default_priceが数字だった場合' do
        parking_area.default_price = 5000
        expect(parking_area).to be_valid
      end

      it 'descriptionが150文字だった場合' do
        parking_area.description = 'あ' * 150
        expect(parking_area).to be_valid
      end
    end

    # 失敗パターン
    context 'バリデーション' do
      it 'nameが21文字以上だった場合' do
        parking_area.name = 'あ' * 21
        expect(parking_area).to be_invalid
      end

      it '同じnameが既に登録されていた場合' do
        parking_area = create(:parking_area, name: 'エリア1', parking_lot: parking_lot)
        parking_area_1 = build(:parking_area, name: 'エリア1', parking_lot: parking_lot)
        expect(parking_area_1).to be_invalid
      end

      it 'nameが空欄だった場合' do
        parking_area.name = nil
        expect(parking_area).to be_invalid
      end

      it 'default_priceが文字だった場合' do
      end

      it 'default_priceが記号が入力されて場合' do
      end

      it 'default_priceが空欄だった場合' do
      end

      it 'descriptionが151文字以上だった場合' do
      end

      it 'parking_lotが紐づいていなかった場合' do
      end
    end
  end

  describe 'アソシエーション' do
    context 'parking_spaceが契約がされていない場合' do
      it 'parking_spaceが契約された場合、削除されない' do
      end
    end

    context 'parking_spaceが一度でも契約された場合' do
      it '契約中のスペースがある場合、ParkingAreaも削除されずに残る' do
      end
    end
  end
end
