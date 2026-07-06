require 'rails_helper'

RSpec.describe Device, type: :model do
  let(:parking_manager) { FactoryBot.create(:parking_manager) }
  let(:device) { FactoryBot.build(:device) }

  describe 'create' do
    # 成功パターン
    context 'バリデーション' do
      it '設定した全てのバリデーションが機能しているか' do
        expect(device).to be_valid
      end
    end

    # 失敗パターン
    context 'バリデーション' do
      it 'device_tokenが重複していた場合' do
        token = SecureRandom.uuid
        device = create(:device, device_token: token)
        device_1 = build(:device, device_token: token)
        
        expect(device_1).to be_invalid
      end

      it 'user_agentがnilの場合' do
        device.user_agent = nil
        expect(device).to be_invalid
      end

      it 'device_tokenがnilの場合' do
        device.device_token = nil
        expect(device).to be_invalid
      end

      it 'expires_atがnilの場合' do
      end

      it 'parking_managerが紐づいていない場合' do
      end
    end

    context 'コールバック' do
      it 'iPhoneからログインするとnameが"iPhone(スマホ)"になる' do
      end

      it 'iPadからログインするとnameが"iPad"になる' do
      end

      it 'MacBookからログインするとnameが"Mac(パソコン)"になる' do
      end

      it 'Windowsからログインするとnameが"Windows(パソコン)"になる' do
      end

      it 'Androidからログインするとnameが"Android端末(スマホ)"になる' do
      end

      it '不明の端末からログインするとnameが"不明な端末"になる' do
      end
    end
  end

  describe 'インスタンスメソッド' do
    describe '#active_and_verified?' do
      it '期間内かつ認証済みの場合、trueを返す' do
      end

      it '期間切れの場合、falseを返す' do
      end

      it '未認証の場合は、falseを返す' do
      end
    end

    describe '#extend_expiration!' do
      it 'expires_atが1ヶ月延長されるか' do
      end

      it 'last_login_atが現在時刻に更新されるか' do
      end
    end

    describe '#verify!' do
      it 'is_verifiedがtrueになるか' do
      end

      it 'device_tokenが再構成されるか' do
      end
    end

    describe '#verify_with_agent!' do
      it 'ログインするとlast_login_atが現在時刻になる' do
      end

      it 'ログインするとexpires_atはログイン時の1ヶ月後になる' do
      end
    end
  end

  describe 'クラスメソッド' do
    describe '.get_type_by_user_agent' do
      it 'iPhoneのUser-Agentを返すと"iPhone(スマホ)"を返す' do
      end

      it 'iPadのUser-Agentを返すと"iPad(タブレット)"を返す' do
      end

      it 'MacBookのUser-Agentを返すと"Mac(パソコン)"を返す' do
      end

      it 'WindowsのUser-Agentを返すと"Windows(パソコン)"を返す' do
      end

      it 'AndroidのUser-Agentを返すと"Android端末(スマホ)"を返す' do
      end

      it '不明な端末のUser-Agentを返すと"不明な端末"を返す' do
      end
    end

    describe '.generate_token' do
      it 'ユニークなトークンを生成するか' do
      end
    end
  end
end
