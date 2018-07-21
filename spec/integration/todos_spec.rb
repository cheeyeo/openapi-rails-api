require 'swagger_helper'

describe 'Todos API', swagger_doc: 'v1/swagger.json' do
  path '/todos' do
    get 'List todos' do
      description 'List all the todos stored'
      tags 'Todos'
      produces 'application/vnd.api+json'
      consumes 'application/vnd.api+json'

      response '200', 'Successful Operation' do
        let!(:todo) { Todo.create!(title: 'Test todo') }

        schema '$ref' => '#/definitions/todos_array'

        run_test! do |response|
          resp = JSON.parse(response.body)
          res = resp['data'].first
          expect(res['type']).to eq('todos')
          expect(Integer(res['id'])).to eq(todo.id)
          expect(res['attributes']['title']).to eq(todo.title)
        end
      end
    end
  end

  path '/todos/{id}' do
    # define id parameter here for all related paths
    parameter name: :id, in: :path, type: :integer

    get 'Retrieve a todo' do
      description 'Get a single Todo by ID'
      tags 'Todos'
      produces 'application/vnd.api+json'
      consumes 'application/vnd.api+json'

      response '200', 'Successful Operation' do
        schema '$ref' => '#/definitions/todo_single'

        let(:todo) { Todo.create!(title: 'Test todo') }
        let(:id) { todo.id }
        run_test! do |response|
          resp = JSON.parse(response.body)
          res = resp['data']
          expect(Integer(res['id'])).to eq(todo.id)
          expect(res['type']).to eq('todos')
          expect(res['attributes']['title']).to eq(todo.title)
        end
      end

      response '404', 'Todo not found' do
        let(:id) { 'invalid' }

        run_test! do |response|
          res = JSON.parse(response.body)['errors'].first
          expect(res['status']).to eq('404')
          expect(res['title']).to eq('Not found')
          expect(res['detail']).to eq("Couldn't find Todo with 'id'=invalid")
          expect(response.status).to eq(404)
        end
      end
    end

    patch 'Update a todo' do
      description 'Update a single Todo by ID'
      tags 'Todos'
      produces 'application/vnd.api+json'
      consumes 'application/vnd.api+json'

      parameter name: :data, in: :body, schema: {
        '$ref' => '#/definitions/todo_parameter'
      }

      let(:todo2) { Todo.create!(title: 'Test todo') }
      let(:id) { todo2.id }

      response '200', 'Successful Operation' do
        schema '$ref' => '#/definitions/todo_single'

        let(:data) do
          {
            data: { type: 'todos', attributes: { title: 'my updated title' } }
          }
        end

        run_test! do |response|
          res = JSON.parse(response.body)
          expect(res['data']['attributes']['title']).to \
            eq('my updated title')
        end
      end

      response '400', 'Missing Request parameters' do
        let(:data) { {} }
        run_test! do |response|
          err = JSON.parse(response.body)['errors'].first
          expect(err['status']).to eq('400')
          expect(err['detail']).to eq('param is missing or the value is empty: data')
          expect(err['title']).to eq("Missing `data` Member at document's top level")
          expect(response.status).to eq(400)
        end
      end

      response '422', 'Invalid Todo Request' do
        let(:data) do
          {
            data: { type: 'todos', attributes: { title: '' } }
          }
        end

        run_test! do |response|
          resp = JSON.parse(response.body)['errors'].first
          expect(resp['status']).to eq('422')
          expect(resp['detail']).to eq('Title cannot be blank')
          expect(resp['title']).to eq('Invalid Attributes')
        end
      end
    end

    delete 'Delete a todo' do
      description 'Delete a Todo via ID'
      tags 'Todos'
      produces 'application/vnd.api+json'
      consumes 'application/vnd.api+json'

      response '204', 'Successful Operation' do
        let(:todo) { Todo.create!(title: 'Test todo') }
        let(:id) { todo.id }
        run_test!
      end
    end
  end

  path '/todos' do
    post 'Creates a todo' do
      description 'Creates a single Todo'
      tags 'Todos'
      consumes 'application/vnd.api+json'
      produces 'application/vnd.api+json'

      parameter name: :data, in: :body, schema: {
        '$ref' => '#/definitions/todo_parameter'
      }

      response '201', 'Successful Operation' do
        schema '$ref' => '#/definitions/todo_single'

        let(:data) do
          {
            data: { type: 'todos', attributes: { title: 'my foo' } }
          }
        end

        run_test! do |response|
          todo = Todo.last
          resp = JSON.parse(response.body)['data']
          expect(Integer(resp['id'])).to eq(todo.id)
          expect(resp['type']).to eq('todos')
          expect(resp['attributes']['title']).to eq(todo.title)
        end
      end

      response '422', 'Invalid Todo Request' do
        let(:data) do
          {
            data: { type: 'todos', attributes: { title: '' } }
          }
        end

        run_test! do |response|
          resp = JSON.parse(response.body)['errors'].first
          expect(resp['title']).to eq('Invalid Attributes')
          expect(resp['detail']).to eq('Title cannot be blank')
          expect(response.status).to eq(422)
        end
      end

      response '400', 'Missing Request parameters' do
        let(:data) { {} }
        run_test! do |response|
          err = JSON.parse(response.body)['errors'].first
          expect(err['detail']).to eq('param is missing or the value is empty: data')
          expect(err['status']).to eq('400')
          expect(err['title']).to eq("Missing `data` Member at document's top level")
          expect(response.status).to eq(400)
        end
      end
    end
  end
end
