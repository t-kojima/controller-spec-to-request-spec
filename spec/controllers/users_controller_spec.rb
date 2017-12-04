require 'rails_helper'

describe UsersController, type: :controller do
  describe 'GET #index' do
    let(:users) { FactoryBot.create_list :user, 10 }

    it 'ステータス200を返すこと' do
      get :index
      expect(response.status).to eq 200
    end

    it 'indexテンプレートで表示すること' do
      get :index
      expect(response).to render_template :index
    end

    it '@usersが取得できていること' do
      get :index
      expect(assigns[:users]).to eq users
    end
  end

  describe 'GET #show' do
    let(:user) { FactoryBot.create :user }

    context 'ユーザーが存在する場合' do
      it 'ステータス200を返すこと' do
        get :show, params: { id: user.id }
        expect(response.status).to eq 200
      end

      it 'showテンプレートで表示すること' do
        get :show, params: { id: user.id }
        expect(response).to render_template :show
      end

      it '@userが取得できていること' do
        get :show, params: { id: user.id }
        expect(assigns[:user]).to eq user
      end
    end

    context 'ユーザーが存在しない場合' do
      it 'レスポンスがRecordNotFound(404)になること' do
        expect { get :show, params: { id: 999 } }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new
      expect(response.status).to eq 200
    end

    it 'new.htmlに遷移すること' do
      get :new
      expect(response).to render_template :new
    end

    it '@userがnewされていること' do
      get :new
      expect(assigns(:user)).to_not be_nil
    end
  end

  describe 'GET #edit' do
    let(:user) { FactoryBot.create(:user) }

    it 'returns a success response' do
      get :edit, params: { id: user.id }
      expect(response.status).to eq 200
    end

    it 'edit.htmlに遷移すること' do
      get :edit, params: { id: user.id }
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new User' do
        expect do
          post :create, params: { user: FactoryBot.attributes_for(:user) }
        end.to change(User, :count).by(1)
      end

      it 'redirects to the created user' do
        post :create, params: { user: FactoryBot.attributes_for(:user) }
        expect(response).to redirect_to(User.last)
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: { user: FactoryBot.attributes_for(:user, :invalid) }
        expect(response).to be_success
      end
    end
  end

  describe 'PUT #update' do
    let(:user) { FactoryBot.create(:user) }

    context 'with valid params' do
      it 'updates the requested user' do
        put :update, params: { id: user.to_param, user: FactoryBot.attributes_for(:user, :new_name) }
        user.reload
        skip('Add assertions for updated state')
      end

      it 'redirects to the user' do
        put :update, params: { id: user.to_param, user: FactoryBot.attributes_for(:user, :new_name) }
        expect(response).to redirect_to(user)
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'edit' template)" do
        put :update, params: { id: user.to_param, user: FactoryBot.attributes_for(:user, :invalid) }
        expect(response).to be_success
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:user) { FactoryBot.create(:user) }

    it 'destroys the requested user' do
      expect do
        delete :destroy, params: { id: user.to_param }
      end.to change(User, :count).by(-1)
    end

    it 'redirects to the users list' do
      delete :destroy, params: { id: user.to_param }
      expect(response).to redirect_to(users_url)
    end
  end
end
