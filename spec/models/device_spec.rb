require 'rails_helper'

RSpec.describe Device, type: :model do
  let(:parking_manager) { FactoryBot.create(:parking_manager) }
  let(:device) { FactoryBot.build(:device) }

  USER_AGENTS = {
    iphone:  "iPhone",
    iPad:    "iPad",
    android: "Android",
    windows: "Windows",
    mac:     "Mac",
    unknown: "UnknownBrowser"
  }.freeze

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
        device.expires_at = nil
        expect(device).to be_invalid
      end

      it 'parking_managerが紐づいていない場合' do
        device.parking_manager = nil
        expect(device).to be_invalid
      end
    end

    context 'コールバック' do
      it 'iPhoneからログインするとnameが"iPhone(スマホ)"になる' do
        device = build(:device, user_agent: "iphone")
        device.valid?

        expect(device.name).to eq "iPhone(スマホ)"
      end

      it 'iPadからログインするとnameが"iPad"になる' do
        device = build(:device, user_agent: "ipad")
        device.valid?

        expect(device.name).to eq "iPad(タブレット)"
      end

      it 'MacBookからログインするとnameが"Mac(パソコン)"になる' do
        device = build(:device, user_agent: "Macintosh")
        device.valid?

        expect(device.name).to eq "Mac(パソコン)"
      end

      it 'Windowsからログインするとnameが"Windows(パソコン)"になる' do
        device = build(:device, user_agent: "windows")
        device.valid?

        expect(device.name).to eq "Windows(パソコン)"
      end

      it 'Androidからログインするとnameが"Android端末(スマホ)"になる' do
        device = build(:device, user_agent: "android")
        device.valid?

        expect(device.name).to eq "Android端末(スマホ)"
      end

      it '対応していない端末からログインするとnameが"不明な端末"になる' do
        device = build(:device, user_agent: "UnknownBrowser/1.0")
        device.valid?

        expect(device.name).to eq "不明な端末"
      end
    end
  end

  describe 'インスタンスメソッド' do
    describe '#active_and_verified?' do
      it '期間内かつ認証済みの場合、trueを返す' do
        device = create(:device, expires_at: 1.month.from_now, is_verified: true)
        
        expect(device.active_and_verified?).to eq true
      end

      it '期間切れかつ認証済みの場合、falseを返す' do
        device = create(:device, expires_at: Date.yesterday, is_verified: true)

        expect(device.active_and_verified?).to eq false
      end

      it '期間内かつ未認証の場合は、falseを返す' do
        device = create(:device, expires_at: 1.month.from_now, is_verified: false)

        expect(device.active_and_verified?).to eq false
      end
    end

    describe '#extend_expiration!' do
      it 'expires_atが1ヶ月延長されるか' do
        device = create(:device, last_login_at: 1.month.ago, expires_at: Time.current)
        device.extend_expiration!

        expect(device.expires_at).to be_within(1.second).of(1.month.from_now)
      end

      it 'last_login_atが現在時刻に更新されるか' do
        device = create(:device, last_login_at: 1.month.ago, expires_at: Time.current)
        device.extend_expiration!

        expect(device.last_login_at).to be_within(1.second).of(Time.current)
      end
    end

    describe '#verify!' do
      it 'is_verifiedがtrueになるか' do
        device = create(:device, is_verified: false)
        device.verify!

        expect(device.is_verified).to eq true
      end

      it 'device_tokenが再構成されるか' do
        device = create(:device)
        old_token = device.device_token
        device.verify!

        expect(device.device_token).not_to eq old_token
      end
    end

    describe '#verify_with_agent!' do
      it 'ログインするとlast_login_atが現在時刻になる' do
        device = create(:device, last_login_at: 1.month.ago)
        device.verify_with_agent!("iPhone")

        expect(device.last_login_at).to be_within(1.second).of(Time.current)
      end

      it 'ログインするとexpires_atはログイン時の1ヶ月後になる' do
        device = create(:device, expires_at: Time.current)
        device.verify_with_agent!("iPhone")

        expect(device.expires_at).to be_within(1.second).of(1.month.from_now)
      end
    end
  end

  describe 'クラスメソッド' do
    describe '.get_type_by_user_agent' do
      it 'iPhoneのUser-Agentを返すと"iPhone(スマホ)"を返す' do
        result = Device.get_type_by_user_agent("iPhone")

        expect(result).to eq "iPhone(スマホ)"
      end

      it 'iPadのUser-Agentを返すと"iPad(タブレット)"を返す' do
        result = Device.get_type_by_user_agent("iPad")

        expect(result).to eq "iPad(タブレット)"
      end

      it 'MacBookのUser-Agentを返すと"Mac(パソコン)"を返す' do
        result = Device.get_type_by_user_agent("Macintosh")

        expect(result).to eq 'Mac(パソコン)'
      end

      it 'WindowsのUser-Agentを返すと"Windows(パソコン)"を返す' do
        result = Device.get_type_by_user_agent("Windows")

        expect(result).to eq 'Windows(パソコン)'
      end

      it 'AndroidのUser-Agentを返すと"Android端末(スマホ)"を返す' do
        result = Device.get_type_by_user_agent("Android")

        expect(result).to eq 'Android端末(スマホ)'
      end

      it '対応していない端末のUser-Agentを返すと"不明な端末"を返す' do
      end
    end

    describe '.generate_token' do
      it 'ユニークなトークンを生成するか' do
      end
    end
  end
end
