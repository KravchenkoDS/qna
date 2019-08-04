require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:awards).dependent(:destroy) }

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
