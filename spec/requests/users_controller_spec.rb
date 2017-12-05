require 'rails_helper'

describe UsersController, type: :request do
  describe 'GET #index' do
    before do
      FactoryBot.create :takashi
      FactoryBot.create :satoshi
    end

    it 'リクエストが成功すること' do
      get users_url
      expect(response.status).to eq 200
    end

    it 'ユーザー名が表示されていること' do
      get users_url
      expect(response.body).to include 'Takashi'
      expect(response.body).to include 'Satoshi'
    end
  end

  describe 'GET #show' do
    context 'ユーザーが存在する場合' do
      let(:takashi) { FactoryBot.create :takashi }

      it 'リクエストが成功すること' do
        get user_url takashi
        expect(response.status).to eq 200
      end

      it 'ユーザー名が表示されていること' do
        get user_url takashi
        expect(response.body).to include 'Takashi'
      end
    end

    context 'ユーザーが存在しない場合' do
      subject { -> { get user_url 1 } }

      it { is_expected.to raise_error ActiveRecord::RecordNotFound }
    end
  end

  describe 'GET #new' do
    it 'リクエストが成功すること' do
      get new_user_url
      expect(response.status).to eq 200
    end
  end

  describe 'GET #edit' do
    let(:takashi) { FactoryBot.create :takashi }

    it 'リクエストが成功すること' do
      get edit_user_url takashi
      expect(response.status).to eq 200
    end

    it 'ユーザー名が表示されていること' do
      get edit_user_url takashi
      expect(response.body).to include 'Takashi'
    end

    it 'メールアドレスが表示されていること' do
      get edit_user_url takashi
      expect(response.body).to include 'takashi@example.com'
    end
  end

  describe 'POST #create' do
    context 'パラメータが妥当な場合' do
      it 'リクエストが成功すること' do
        post users_url, params: { user: FactoryBot.attributes_for(:user) }
        expect(response.status).to eq 302
      end

      it 'ユーザーが登録されること' do
        expect do
          post users_url, params: { user: FactoryBot.attributes_for(:user) }
        end.to change(User, :count).by(1)
      end

      it 'リダイレクトすること' do
        post users_url, params: { user: FactoryBot.attributes_for(:user) }
        expect(response).to redirect_to User.last
      end
    end

    context 'パラメータが不正な場合' do
      it 'リクエストが成功すること' do
        post users_url, params: { user: FactoryBot.attributes_for(:user, :invalid) }
        expect(response.status).to eq 200
      end

      it 'ユーザーが登録されないこと' do
        expect do
          post users_url, params: { user: FactoryBot.attributes_for(:user, :invalid) }
        end.to_not change(User, :count)
      end

      it 'エラーが表示されること' do
        post users_url, params: { user: FactoryBot.attributes_for(:user, :invalid) }
        expect(response.body).to include 'prohibited this user from being saved'
      end
    end
  end

  describe 'PUT #update' do
    let(:takashi) { FactoryBot.create :takashi }

    context 'パラメータが妥当な場合' do
      it 'リクエストが成功すること' do
        put user_url takashi, params: { user: FactoryBot.attributes_for(:satoshi) }
        expect(response.status).to eq 302
      end

      it 'ユーザー名が更新されること' do
        expect do
          put user_url takashi, params: { user: FactoryBot.attributes_for(:satoshi) }
        end.to change { User.find(takashi.id).name }.from('Takashi').to('Satoshi')
      end

      it 'リダイレクトすること' do
        put user_url takashi, params: { user: FactoryBot.attributes_for(:satoshi) }
        expect(response).to redirect_to User.last
      end
    end

    context 'パラメータが不正な場合' do
      it 'リクエストが成功すること' do
        put user_url takashi, params: { user: FactoryBot.attributes_for(:user, :invalid) }
        expect(response.status).to eq 200
      end

      it 'ユーザー名が変更されないこと' do
        expect do
          put user_url takashi, params: { user: FactoryBot.attributes_for(:user, :invalid) }
        end.to_not change(User.find(takashi.id), :name)
      end

      it 'エラーが表示されること' do
        put user_url takashi, params: { user: FactoryBot.attributes_for(:user, :invalid) }
        expect(response.body).to include 'prohibited this user from being saved'
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:user) { FactoryBot.create :user }

    it 'リクエストが成功すること' do
      delete user_url user
      expect(response.status).to eq 302
    end

    it 'ユーザーが削除されること' do
      expect do
        delete user_url user
      end.to change(User, :count).by(-1)
    end

    it 'ユーザー一覧にリダイレクトすること' do
      delete user_url user
      expect(response).to redirect_to(users_url)
    end
  end
end
