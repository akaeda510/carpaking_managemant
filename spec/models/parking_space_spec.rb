require 'rails_helper'

RSpec.describe ParkingSpace, type: :model do
    let(:parking_area) { FactoryBot.create(:parking_area) }
    let(:parking_space) { FactoryBot.build(:parking_space) }

  describe 'create' do
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

      it 'priceが空欄だった場合' do
        parking_space.price = nil
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
        space_name = create(:parking_space, name: '1', parking_area: parking_area)
        space_name_1 = build(:parking_space, name: '1', parking_area: parking_area)
        expect(space_name_1).to be_invalid
      end

      it 'nameが空欄だった場合' do
        parking_space.name = nil
        expect(parking_space).to be_invalid
      end

      it 'desctiptionが151文字以上だった場合' do
        parking_space.description = 'あ' * 151
        expect(parking_space).to be_invalid
      end

      it 'widthが-1だった場合' do
        parking_space.width = '-1'
        expect(parking_space).to be_invalid
      end

      it 'widthが10だった場合' do
        parking_space.width = 10
        expect(parking_space).to be_invalid
      end

      it 'widthが文字列だった場合' do
        parking_space.width = '二'
        expect(parking_space).to be_invalid
      end

      it 'widthが空欄だった場合' do
        parking_space.width = nil
        expect(parking_space).to be_invalid
      end

      it 'lengthが-1だった場合' do
        parking_space.length = '-1'
        expect(parking_space).to be_invalid
      end

      it 'lengthが10だった場合' do
        parking_space.length = 10
        expect(parking_space).to be_invalid
      end

      it 'lengthが文字列だった場合' do
        parking_space.length = '二'
        expect(parking_space).to be_invalid
      end

      it 'lengthが空欄だった場合' do
        parking_space.length = nil
        expect(parking_space).to be_invalid
      end

      it 'priceが負の数値だった場合' do
        parking_space.price = '-1000'
        expect(parking_space).to be_invalid
      end

      it 'priceが小数だった場合' do
        parking_space.price = '1000.1'
        expect(parking_space).to be_invalid
      end

      it 'parking_areaが紐づいていなかった場合' do
        parking_space.parking_area = nil
        expect(parking_space).to be_invalid
      end
    end
  end

  describe 'update' do
    # 成功パターン
    context 'バリデーション' do
      context 'parking_spaceが契約記録がない場合' do
        it 'nameが変更することができる' do
          parking_space = create(:parking_space, name: '1', parking_area: parking_area)
          parking_space.name = '2'
          expect(parking_space).to be_valid
        end
      end
    end

    # 失敗パターン
    context 'バリデーション' do
      it '作成されたスペースのpriceを空欄にした場合' do
        parking_space = create(:parking_space, price: 5000, parking_area: parking_area)
        parking_space.update(price: nil)
        expect(parking_space).to be_invalid
      end

      context 'parking_spaceが契約履歴がある時' do
        it 'nameの変更を無効になる' do
          parking_space = create(:parking_space, name: '1', status: 'contracted', parking_area: parking_area)
          create(:contract_parking_space, parking_space: parking_space)
          parking_space.name = '2'
          expect(parking_space).to be_invalid
        end

        it 'statusが"contracted"に変更されるか' do
          skip '未実装のため後日実装'
        end
      end
    end
  end

  describe 'アソシエーション' do
    context 'parking_spaceが一度でも駐車場契約された' do
      it 'parking_spaceを削除されずに残る' do
        parking_space = create(:parking_space, parking_area: parking_area)
        create(:contract_parking_space, parking_space: parking_space)
        expect { parking_space.destroy }.to raise_error(ActiveRecord::DeleteRestrictionError)
         expect(ParkingSpace.exists?(parking_space.id)).to be true
      end
    end
  end
end
