require 'rails_helper'

describe User do
  describe '::create_with_omniauth' do
    let(:params) do
      params = {}
      params['uid'] = '123'
      info = params['info'] = {}
      info['name'] = 'Alice'
      info['image'] = 'https://avatars.githubusercontent.com/u/1148320?v=2'
      info['email'] = 'alice@example.com'
      info['nickname'] = 'alice'
      info['location'] = 'Kobe'
      urls = info['urls'] = {}
      urls['GitHub'] = 'https://github.com/alice-foo-bar'
      urls['Blog'] = 'http://blog.example.com'

      params
    end

    it 'saves attributes' do
      user = User.create_with_omniauth(params)
      expected_attributes = {
          github_id: '123',
          name: 'Alice',
          image: 'https://avatars.githubusercontent.com/u/1148320?v=2',
          email: 'alice@example.com',
          nickname: 'alice',
          location: 'Kobe',
          github_url: 'https://github.com/alice-foo-bar',
          blog: 'http://blog.example.com'
      }
      expect(user).to have_attributes(expected_attributes)
      expect(user).to be_persisted
    end
  end

  describe 'validation' do
    it 'editは無効なnicknameとすること' do
      user = User.new(github_id: '123', nickname: 'Alice')
      expect(user).to be_valid

      user.nickname = 'edit'
      expect(user).to be_invalid

      user.nickname = 'Edit'
      expect(user).to be_invalid
    end
  end

  describe '#age' do
    before do
      Timecop.travel(2013, 1, 10)
    end
    it '年齢が自動計算されること' do
      user = User.new(birthday: '1981/1/16')
      expect(user.age).to eq 31
    end

    it '生年月日が入力されていなければnilが返って来ること' do
      user = User.new(birthday: nil)
      expect(user.age).to eq nil
    end
  end

  describe '#active?' do
    let(:user) { User.new }
    it 'introductionが入っていればactiveであること' do
      user.introduction = 'introduction'
      expect(user.active?).to eq true
    end

    it 'introductionがnilならばactiveでないこと' do
      user.introduction = nil
      expect(user.active?).to eq false
    end

    it 'introductionが空文字ならばactiveでないこと' do
      user.introduction = ''
      expect(user.active?).to eq false
    end
  end
end
