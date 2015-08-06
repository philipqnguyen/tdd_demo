class TodosController < ApplicationController
  def index
    # @todos = Todo.all # get rid of this
    @todos = Todo.where(completed: false) # Add this
  end
end
