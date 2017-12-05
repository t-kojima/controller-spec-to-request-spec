require 'rails_helper'

describe UsersController, type: :controller do
  describe 'GET #index' do
    let(:users) { FactoryBot.create_list :user, 2 }

    it 'リクエストが成功すること' do
      get :index
      p "body: #{response.body}"
      expect(response.status).to eq 200
    end

    it 'indexテンプレートで表示されること' do
      get :index
      expect(response).to render_template :index
    end

    it '@usersが取得できていること' do
      get :index
      expect(assigns :users).to eq users
    end
  end

  describe 'GET #show' do
    context 'ユーザーが存在する場合' do
      let(:takashi) { FactoryBot.create :takashi }

      it 'リクエストが成功すること' do
        get :show, params: { id: takashi }
        expect(response.status).to eq 200
      end

      it 'showテンプレートで表示されること' do
        get :show, params: { id: takashi }
        expect(response).to render_template :show
      end

      it '@userが取得できていること' do
        get :show, params: { id: takashi }
        expect(assigns :user).to eq takashi
      end
    end

    context 'ユーザーが存在しない場合' do
      subject { -> { get :show, params: { id: 1 } } }

      it { is_expected.to raise_error ActiveRecord::RecordNotFound }
    end
  end

  describe 'GET #new' do
    it 'リクエストが成功すること' do
      get :new
      expect(response.status).to eq 200
    end

    it 'newテンプレートで表示されること' do
      get :new
      expect(response).to render_template :new
    end

    it '@userがnewされていること' do
      get :new
      expect(assigns :user).to_not be_nil
    end
  end

  describe 'GET #edit' do
    let(:takashi) { FactoryBot.create(:takashi) }

    it 'リクエストが成功すること' do
      get :edit, params: { id: takashi }
      expect(response.status).to eq 200
    end

    it 'editテンプレートで表示されること' do
      get :edit, params: { id: takashi }
      expect(response).to render_template :edit
    end

    it '@userが取得できていること' do
      get :show, params: { id: takashi }
      expect(assigns :user).to eq takashi
    end
  end

  describe 'POST #create' do
    context 'パラメータが妥当な場合' do
      it 'リクエストが成功すること' do
        post :create, params: { user: FactoryBot.attributes_for(:user) }
        expect(response.status).to eq 302
      end

      it 'ユーザーが登録されること' do
        expect do
          post :create, params: { user: FactoryBot.attributes_for(:user) }
        end.to change(User, :count).by(1)
      end

      it 'リダイレクトすること' do
        post :create, params: { user: FactoryBot.attributes_for(:user) }
        expect(response).to redirect_to User.last
      end
    end

    context 'パラメータが不正な場合' do
      it 'リクエストが成功すること' do
        post :create, params: { user: FactoryBot.attributes_for(:user, :invalid) }
        expect(response.status).to eq 200
      end

      it 'ユーザーが登録されないこと' do
        expect do
          post :create, params: { user: FactoryBot.attributes_for(:user, :invalid) }
        end.to_not change User, :count
      end

      it 'newテンプレートで表示されること' do
        post :create, params: { user: FactoryBot.attributes_for(:user, :invalid) }
        expect(response).to render_template :new
      end

      it 'エラーが表示されること' do
        post :create, params: { user: FactoryBot.attributes_for(:user, :invalid) }
        expect(assigns(:user).errors.any?).to be_truthy
      end
    end
  end

  describe 'PUT #update' do
    let(:takashi) { FactoryBot.create :takashi }

    context 'パラメータが妥当な場合' do
      it 'リクエストが成功すること' do
        put :update, params: { id: takashi, user: FactoryBot.attributes_for(:satoshi) }
        expect(response.status).to eq 302
      end

      it 'ユーザー名が更新されること' do
        expect do
          put :update, params: { id: takashi, user: FactoryBot.attributes_for(:satoshi) }
        end.to change { User.find(takashi.id).name }.from('Takashi').to('Satoshi')
      end

      it 'リダイレクトすること' do
        put :update, params: { id: takashi, user: FactoryBot.attributes_for(:satoshi) }
        expect(response).to redirect_to User.last
      end
    end

    context 'パラメータが不正な場合' do
      it 'リクエストが成功すること' do
        put :update, params: { id: takashi, user: FactoryBot.attributes_for(:user, :invalid) }
        expect(response.status).to eq 200
      end

      it 'ユーザー名が変更されないこと' do
        expect do
          put :update, params: { id: takashi, user: FactoryBot.attributes_for(:user, :invalid) }
        end.to_not change(User.find(takashi.id), :name)
      end

      it 'editテンプレートで表示されること' do
        put :update, params: { id: takashi, user: FactoryBot.attributes_for(:user, :invalid) }
        expect(response).to render_template :edit
      end

      it 'エラーが表示されること' do
        put :update, params: { id: takashi, user: FactoryBot.attributes_for(:user, :invalid) }
        expect(assigns(:user).errors.any?).to be_truthy
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:user) { FactoryBot.create :user }

    it 'リクエストが成功すること' do
      delete :destroy, params: { id: user }
      expect(response.status).to eq 302
    end

    it 'ユーザーが削除されること' do
      expect do
        delete :destroy, params: { id: user }
      end.to change(User, :count).by(-1)
    end

    it 'ユーザー一覧にリダイレクトすること' do
      delete :destroy, params: { id: user }
      expect(response).to redirect_to(users_url)
    end
  end
end
