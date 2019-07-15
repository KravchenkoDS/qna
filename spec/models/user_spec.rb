require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:questions).dependent(:destroy) }

  let(:user) { create(:user) }
  let(:own_question) { create(:question, user: user) }
  let(:question) { create(:question) }
end
