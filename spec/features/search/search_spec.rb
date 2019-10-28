require 'sphinx_helper'

feature 'Everyone can use the search.', %q{
  To find information visitors can use the search to find
  Users, questions, answers and comments
} do

  given!(:users) { create_list(:user, 2) }
  given!(:questions) { create_list(:question, 2, author: users.first) }
  given!(:answers) { create_list(:answer, 2, question: questions.first, author: users.last) }
  given!(:comments) { create_list(:comment, 2, commentable: questions.first, user: users.last) }

  background do
    visit root_path
  end

  describe 'Search in all items', sphinx: true, js:true do
    scenario 'with empty search string' do
      ThinkingSphinx::Test.run do
        click_on 'Search'

        users.each { |u| expect(page).to have_content u.email }
        questions.each { |q| expect(page).to have_content q.title }
        answers.each { |a| expect(page).to have_content a.body }
        comments.each { |c| expect(page).to have_content c.body }
      end
    end

    scenario 'with search string' do
      fill_in :search_search_string, with: questions.last.title
      ThinkingSphinx::Test.run do
        click_on 'Search'

        users.each { |u| expect(page).to_not have_content u.email }
        answers.each { |a| expect(page).to_not have_content a.body }
        comments.each { |c| expect(page).to_not have_content c.body }
        expect(page).to have_content questions.last.title
        expect(page).to_not have_content questions.first.title
      end
    end
  end

  describe 'Search in only questions', sphinx: true, js:true  do
    background do
      select('question', from: 'search_search_type')
    end

    scenario 'lists all questions' do
      ThinkingSphinx::Test.run do
        click_on 'Search'

        questions.each { |q| expect(page).to have_content q.title }
        users.each { |u| expect(page).to_not have_content u.email }
        answers.each { |a| expect(page).to_not have_content a.body }
        comments.each { |c| expect(page).to_not have_content c.body }
      end
    end

    scenario 'lists questions with search string' do
      fill_in :search_search_string, with: questions.last.title
      ThinkingSphinx::Test.run do
        click_on 'Search'

        expect(page).to have_content questions.last.title
        expect(page).to_not have_content questions.first.title
      end
    end
  end

  describe 'Search in only answers', sphinx: true, js:true  do
    background do
      select('answer', from: 'search_search_type')
    end

    scenario 'lists all answers' do
      ThinkingSphinx::Test.run do
        click_on 'Search'

        questions.each { |q| expect(page).to_not have_content q.body }
        users.each { |u| expect(page).to_not have_content u.email }
        answers.each { |a| expect(page).to have_content a.body }
        comments.each { |c| expect(page).to_not have_content c.body }
      end
    end

    scenario 'lists answers with search string' do
      fill_in :search_search_string, with: answers.last.body
      ThinkingSphinx::Test.run do
        click_on 'Search'

        expect(page).to have_content answers.last.body
        expect(page).to_not have_content answers.first.body
      end
    end
  end

  describe 'Search in only comments', sphinx: true, js:true  do
    background do
      select('comment', from: 'search_search_type')
    end

    scenario 'lists all comments' do
      ThinkingSphinx::Test.run do
        click_on 'Search'

        questions.each { |q| expect(page).to_not have_content q.body }
        users.each { |u| expect(page).to_not have_content u.email }
        answers.each { |a| expect(page).to_not have_content a.body }
        comments.each { |c| expect(page).to have_content c.body }
      end
    end

    scenario 'lists comments with search string' do
      fill_in :search_search_string, with: comments.last.body
      ThinkingSphinx::Test.run do
        click_on 'Search'

        expect(page).to have_content comments.last.body
        expect(page).to_not have_content comments.first.body
      end
    end
  end


  describe 'Search in only users', sphinx: true, js:true  do
    background do
      select('user', from: 'search_search_type')
    end

    scenario 'lists all users' do
      ThinkingSphinx::Test.run do
        click_on 'Search'

        questions.each { |q| expect(page).to_not have_content q.body }
        users.each { |u| expect(page).to have_content u.email }
        answers.each { |a| expect(page).to_not have_content a.body }
        comments.each { |c| expect(page).to_not have_content c.body }
      end
    end

    scenario 'Serch user with search string', sphinx: true, js:true do
      fill_in :search_search_string, with: users.first.email.split('@')[0]
      ThinkingSphinx::Test.run do
        click_on 'Search'

        expect(page).to have_content users.first.email
        expect(page).to_not have_content users.last.email
      end
    end
  end
end
