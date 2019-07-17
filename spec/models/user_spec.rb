require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:questions).dependent(:destroy) }

  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:owner_question) { create(:question, user: user) }

  it 'Author' do
    expect(user).to be_author(owner_question)
  end

  it 'Not author' do
    expect(user).to_not be_author(question)
  end
end
