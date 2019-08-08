require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :user }
  it { should belong_to :votable }

  let(:question) { create(:question) }
  let(:user) { create(:user) }
  let!(:vote_test_1) { create(:vote, votable: question, user: user) }

  it 'validate uniqueness user with scope votable' do
    vote_test_2 = Vote.new(votable: question, user: user)
    expect(vote_test_2).to_not be_valid
  end

  it 'validate uniqueness user with scope votable'do
    expect(Vote.new(votable: question, user: user)).
        to validate_uniqueness_of(:user).scoped_to(:votable).with_message('User cannot vote twice')
  end

  it 'validate user not author votable' do
    vote_test_2 = Vote.new(votable: question, user: question.user)
    expect(vote_test_2).to_not be_valid
  end

  it 'vote up' do
    vote_test_1.up
    expect(vote_test_1.value).to eq 1
  end

  it 'vote down' do
    vote_test_1.down
    expect(vote_test_1.value).to eq(-1)
  end
end
