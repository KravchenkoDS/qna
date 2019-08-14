require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should belong_to :user }
  it { should belong_to :commentable }

  it { should validate_presence_of :body }

  it 'ascending identifier' do
    expect(Comment.all.to_sql).to eq Comment.all.order(id: :asc).to_sql
  end
end
