module Api
  module V1
    class TodosController < ApplicationController
      def index
        @todos = Todo.all.order(created_at: :desc)
        render json: @todos, status: :ok
      end

      def show
        @todo = Todo.find(params[:id])
        render json: @todo, status: :ok
      end

      def create
        @todo = Todo.new(todo_params)
        @todo.save!
        render json: @todo, status: :created
      end

      def update
        @todo = Todo.find(params[:id])
        @todo.update!(todo_params)
        render json: @todo, status: :ok
      end

      def destroy
        @todo = Todo.find(params[:id])
        @todo.destroy
        render status: :no_content
      end

      private

      def todo_params
        params.require(:todo).permit(:title)
      end
    end
  end
end
