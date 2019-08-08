require 'rails_helper'

shared_examples_for 'votable' do
  it { should have_many(:votes).dependent(:destroy) }

  let(:model) { create described_class.to_s.underscore.to_sym }
  let(:users) { create_list :user, 3 }

  it 'calculate score' do
    users.each { |u| create(:vote, votable: model, user: u) }
    expect(model.score).to eq users.count
  end
end
