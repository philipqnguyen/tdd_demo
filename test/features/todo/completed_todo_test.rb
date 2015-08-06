require 'test_helper'

describe 'As a user, I want to view incomplete todo items on the index page' do
  before do
    visit '/todos' # todos_path
  end

  it 'should show only the incompleted todo items' do
    page.must_have_content todos(:incompleted).description
  end

  it 'should not show the completed todo items' do
    page.wont_have_content todos(:completed).description
  end
end
