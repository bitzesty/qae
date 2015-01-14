require 'rails_helper'

RSpec.describe SupportLettersController, :type => :controller do
  context 'access key check' do
    let!(:supporter) { create(:supporter) }

    it 'renders 404 if access key is invalid' do
      get :show, access_key: 'hack'

      expect(response.status).to eq(404)
    end

    it 'builds support letter if access key is valid' do
      get :show, access_key: supporter.access_key

      expect(response.status).to eq(200)
      expect(assigns(:support_letter).supporter).to eq(supporter)
    end
  end
end
