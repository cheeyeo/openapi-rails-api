module Api
  module V1
    class TodosController < ApplicationController
      before_action :set_todo, only: [:show, :update, :destroy]

      def index
        @todos = Todo.all.order(created_at: :desc)
        render json: @todos, status: :ok
      end

      def show
        render json: @todo, status: :ok
      end

      def create
        @todo = Todo.new(todo_attributes)
        @todo.save!
        render json: @todo, status: :created, location: api_v1_todo_path(@todo)
      end

      def update
        @todo.update!(todo_attributes)
        render json: @todo, status: :ok
      end

      def destroy
        @todo.destroy
        head 204
      end

      private

      def set_todo
        @todo = Todo.find(params[:id])
      end

      def todo_params
        params.require(:data).permit(
          :type,
          :id,
          attributes: [:title]
        )
      end

      def todo_attributes
        todo_params[:attributes] || {}
      end
    end
  end
end
