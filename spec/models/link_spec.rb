require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  it { should_not allow_values('rbc_o.ru', '', nil).for(:url) }

  context 'test links as gist url' do
    let(:question) { create(:question) }
    let(:gist_url) { 'https://gist.github.com/KravchenkoDS/6a2970b1d11897016737dbd24c566431' }
    let(:gist_link) { question.links.create!(name:'Gist link', url: gist_url) }
    let(:not_gist_link) { question.links.create!(name:'Google link', url: 'https://google.com') }

    it 'gist link is gist?' do
      expect(gist_link).to be_gist_url
    end

    it 'not gist link is gist?' do
      expect(not_gist_link).to_not be_gist_url
    end
  end
end
