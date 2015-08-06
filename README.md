# Test Driven Development Demo

## Configuration

1. Start a new rails app with `rails new tdd_demo` and perform all of your required steps such as `gem install bundler` (if you don't already have it).

2. Place the following gems in the Gemfile:
  ``` ruby
  group :test do
    gem 'minitest-rails', '2.1.1'
    gem 'minitest-rails-capybara', '2.1.1'
    gem 'launchy'
  end
  ```

. Run `bundle install`

3. Require the appropriate minitest files in test_helper.rb:
  ``` ruby
  ENV['RAILS_ENV'] ||= 'test'
  require File.expand_path('../../config/environment', __FILE__)
  require 'rails/test_help'
  require "minitest/rails"           # Add this
  require "minitest/rails/capybara"  # Add this
  require "minitest/pride"           # Add this
  ```

4. Add the following configuration settings to the bottom of test_helper.rb:
  ``` ruby
  # Spec class for spec/features/**
  class FeatureSpec < Capybara::Rails::TestCase
    include Capybara::DSL
    Capybara.default_driver = :rack_test
    # Capybara.javascript_driver = :poltergeist
    register_spec_type(/page$/, self)
  end
  ```

5. Add the following rake configuration code to your Rakefile:
  ``` ruby
  task default: 'test:run'

  Rake::Task['test:run'].enhance ['test:features']

  Rails::TestTask.new('test:features' => 'test:prepare') do |t|
    t.pattern = 'test/**/**/**_test.rb'
  end
  ```

## Problem 1: As a user, I want to view incomplete todo items on the index page. so that I can quickly see what I need to do.

6. Migrate a new model for todos:
  ``` ruby
  rails g model Todo name:string description:text completed:boolean
  ```

7. Fixtures are dummy data used to test your application. Replace the existing test/fixtures/todos.yml file with the following content:
  ``` ruby
  incompleted:
    name: Get groceries
    description: Go to walmart and buy tacos
    completed: false

  completed:
    name: Order cable TV
    description: Call Charter and get the cheapest plan
    completed: true
  ```

8. Let's add the first test file. Create the following file and accompanying directory:  test/features/todo/completed_todo_test.rb

9. Add the following test code in test/features/todo/completed_todo_test.rb:
  ``` ruby
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
  ```

10. Run `bundle exec rake`
  * Errors should show up mentioning that there are no route that matches [GET] '/todos'

11. Let's fix that by adding the route in the config/routes.rb file:
  ``` ruby
  resources :todos, only: [:index] # get 'todos' => 'todo#index'
  ```

12. Run 'bundle exec rake'
  * Errors should show up and complains about `uninitialized constant TodosController`

13. Let's fix that by creating app/controllers/todos_controller.rb file and add the following code:
  ``` ruby
  class TodosController < ApplicationController
  end
  ```

14. Run 'bundle exec rake'
  * Errors should complain that `The action 'index' could not be found for TodosController`

15. Let's fix that by adding the index action into the todos_controller.rb
  ``` ruby
  class TodosController < ApplicationController
    def index # add this method
      @todos = Todo.all
    end
  end
  ```

16. Run 'bundle exec rake'
  * Errors should complain about 'Missing template todos/index'

17. Let's fix that by creating the template app/views/todos/index.html.erb and add the following code:
  ``` erb
  <ul>
    <% @todos.each do |todo| %>
      <li><%= todo.name %> | <%= todo.description %></li>
    <% end %>
  </ul>
  ```

18. Run 'bundle exec rake'
  * This time, our test fails with `Expected not to include "Call Charter and get the cheapest plan"`
  * That was the completed todo item... it shouldn't show up on the index page.

19. Let's fix that by going back into the controller and assign only the incomplete todo items to the instance variable.
  ``` ruby
  class TodosController < ApplicationController
    def index
      # @todos = Todo.all # get rid of this
      @todos = Todo.where(completed: false) # Add this
    end
  end
  ```

20. Let's run 'bundle exec rake'
  * Everything passes =)

21. To prove that everything works, in the terminal run `RAILS_ENV=test rails s` and then navigate to localhost:3000/todos
