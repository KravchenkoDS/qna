require 'rails_helper'

RSpec.describe Answer, type: :model do
    it { should belong_to :question }
    it { should belong_to :user }
    it { should have_many(:links).dependent(:destroy) }

    it { should validate_presence_of :body }

    it { should accept_nested_attributes_for :links }

    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }
    let!(:answer2) { create(:answer, question: question) }

    it_behaves_like "votable"

    it 'have many attached files' do
        expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
    end

    it 'mark answer as best' do
        answer.best!
        expect(answer).to be_best
        expect(answer.user.awards.last).to eq answer.question.award
    end

    it 'Best answer may be only one' do
        answer.best!
        answer2.best!
        answer.reload
        expect(answer).to_not be_best
    end

    it 'Best answer on the first place' do
        answer2.best!
        expect(Answer.first).to eq(answer2)
    end
end
