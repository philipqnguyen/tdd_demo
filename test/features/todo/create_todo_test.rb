require 'test_helper'

describe 'As a user, I want to create a todo from the index page' do
  it 'should create a new todo' do
    visit todos_path
    click_on 'New Todo'

    fill_in 'Name', with: 'Buy a TV'
    fill_in 'Description', with: 'We need a TV to go with our new cable'
    click_on 'Create Todo'

    page.current_path.must_equal todo_path(Todo.last)
    page.must_have_content 'Buy a TV'
    page.must_have_content 'We need a TV to go with our new cable'
  end
end
