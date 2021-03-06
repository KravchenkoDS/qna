require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:awards).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }

  describe 'author of' do
    let(:user) { create(:user) }
    let(:own_question) { create(:question, user: user) }
    let(:question) { create(:question) }

    it 'Author question' do
      expect(user).to be_author(own_question)
    end

    it 'Not author question' do
      expect(user).to_not be_author(question)
    end
  end

  describe '.find_for_oauth' do
    let(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '1084236') }
    let(:service) { double('Services::FindForOauth') }

    it 'calls Services::FindForOauth' do
      expect(Services::FindForOauth).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end

  describe '#subscribed?' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question) }

    it 'subscribed' do
      expect(user).to_not be_subscribed(question)
    end

    it 'is not subscribed' do
      Subscription.create(question: question, user: user)

      expect(user).to be_subscribed(question)
    end
  end

  describe '#subscription' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question) }
    let!(:subscription) { create(:subscription, user: user, question: question) }

    it 'return subscription' do
      expect(user.subscription(question)).to eq subscription
    end
  end
end
