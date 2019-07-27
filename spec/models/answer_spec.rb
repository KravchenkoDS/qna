require 'rails_helper'

RSpec.describe Answer, type: :model do
    it { should belong_to :question }
    it { should belong_to :user }

    it { should validate_presence_of :body }

    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }
    let!(:answer2) { create(:answer, question: question) }

    it 'answer as best' do
        answer.set_best!
        expect(answer).to be_best
    end

    it 'answer may be only one' do
        answer.set_best!
        answer2.set_best!
        answer.reload
        expect(answer).to_not be_best
    end

    it 'Best answer on the first place' do
        answer2.set_best!
        expect(Answer.first).to eq(answer2)
    end
end

