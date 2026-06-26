require 'rails_helper'

RSpec.describe ParkingSpace, type: :model do
  describe 'create' do
    let(:parking_area) { FactoryBot.create(:parking_area) }   
    let(:parking_space) { FactoryBot.build(:parking_space) }

    # 成功パターン
    context 'バリデーション' do
      it '設定した全てのバリデーションが機能しているか' do
        expect(parking_space).to be_valid
      end

      it 'nameが10文字だった場合' do
        parking_space.name = 'あ' * 10
        expect(parking_space).to be_valid
      end

      it 'descriptionが150文字だった場合' do
        parking_space.description = 'あ' * 150
        expect(parking_space).to be_valid
      end

      it 'widthが0だった場合' do
        parking_space.width = 0
        expect(parking_space).to be_valid
      end

      it 'widthが9.9だった場合' do
        parking_space.width = 9.9
        expect(parking_space).to be_valid
      end

      it 'lengthが0だった場合' do
        parking_space.length = 0
        expect(parking_space).to be_valid
      end

      it 'lengthが9.9だった場合' do
        parking_space.length = 9.9
        expect(parking_space).to be_valid
      end

      it 'priceが0だった場合' do
        parking_space.price = 0
        expect(parking_space).to be_valid
      end
    end

    # 失敗パターン
    context 'バリデーション' do
      it 'nameが11文字だった場合' do
        parking_space.name = 'あ' * 11
        expect(parking_space).to be_invalid
      end

      it 'nameが既に登録されていた場合' do
      end

      it 'nameが空欄だった場合' do
      end

      it 'desctiptionが151文字以上だった場合' do
      end

      it 'widthが-1だった場合' do
      end

      it 'widthが10だった場合' do
      end

      it 'widthが文字列だった場合' do
      end

      it 'widthが空欄だった場合' do
      end

      it 'lengthが-1だった場合' do
      end

      it 'lengthが10だった場合' do
      end

      it 'lengthが文字列だった場合' do
      end

      it 'lengthが空欄だった場合' do
      end

      it 'priceが-1だった場合' do
      end

      it 'priceが小数だった場合' do
      end

      it 'priceが文字列だった場合' do
      end

      it 'priceが空欄だった場合' do
      end

      it 'parking_areaが紐づいていなかった場合' do
      end
    end
  end

  describe 'update' do
    context 'バリデーション' do
      context 'parking_spaceがcontractedの場合' do
        it 'nameが変更を無効になる' do
        end
      end

      context 'parking_spaceがcontractedでない場合' do
        it 'nameが変更することができる' do
        end
      end
    end

    context 'parking_spaceが駐車場契約された時' do
      it 'statusが"contracted"に変更されるか' do
        skip '未実装のため後日実装'
      end
    end
  end

  describe 'アソシエーション' do
    context 'parking_spaceが一度でも駐車場契約された' do
      it 'parking_spaceを削除されずに残る' do
      end
    end
  end
end
