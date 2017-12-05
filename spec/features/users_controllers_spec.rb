require 'rails_helper'

describe UsersController, type: :feature do
  describe '' do
    let(:users) { FactoryBot.create_list :user, 10 }

    it 'ステータス200を返すこと' do
      get users_url
      expect(response.status).to eq 200
    end

    it 'indexテンプレートで表示すること' do
      get users_url
      expect(response).to render_template :index
    end

    #it '@usersが取得できていること' do
    #  get :index
    #  expect(assigns[:users]).to eq users
    #end
  end
end
