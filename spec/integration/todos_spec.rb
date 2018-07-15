require 'swagger_helper'

describe 'Todos API', swagger_doc: 'v1/swagger.json' do
  path '/todos' do
    get 'List todos' do
      description 'List all the todos stored'
      tags 'Todos'
      produces 'application/vnd.api+json'

      response '200', 'Successful Operation' do
        let!(:todo) { Todo.create!(title: 'Test todo') }

        schema type: :object,
          required: %w[data],
          properties: {
            data: {
              type: :array,
              items: {
                type: :object,
                required: %w[id type attributes],
                properties: {
                  id: { type: :string },
                  type: { type: :string },
                  attributes: {
                    type: :object,
                    properties: {
                      title: { type: :string }
                    }
                  }
                }
              }
            }
          }

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
      tags 'Todos'
      produces 'application/vnd.api+json'

      response '200', 'Successful Operation' do
        schema type: :object,
          required: %w[data],
          properties: {
            data: {
              type: :object,
              properties: {
                id: { type: :string },
                type: { type: :string },
                attributes: {
                  type: :object,
                  properties: {
                    title: { type: :string }
                  }
                }
              }
            }
          }

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
        schema type: :object,
          properties: {
            code: { type: :string },
            message: { type: :string }
          },
          required: %w[code message]

        let(:id) { 'invalid' }
        run_test! do |response|
          res = JSON.parse(response.body)
          expect(res['code']).to eq('404')
          expect(res['message']).to eq("Couldn't find Todo with 'id'=invalid")
        end
      end
    end

    put 'Update a todo' do
      let(:todo2) { Todo.create!(title: 'Test todo') }
      let(:id) { todo2.id }

      tags 'Todos'
      produces 'application/vnd.api+json'
      # Need to specify consumes else the todo params
      # don't get passed to controller...
      consumes 'application/json'

      parameter name: :todo, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string }
        },
        required: %w[title]
      }

      response '200', 'Successful Operation' do
        schema type: :object,
          required: %w[data],
          properties: {
            data: {
              type: :object,
              properties: {
                id: { type: :string },
                type: { type: :string },
                attributes: {
                  type: :object,
                  properties: {
                    title: { type: :string }
                  }
                }
              }
            }
          }

        let(:todo) do
          { title: 'updated title' }
        end

        run_test! do |response|
          res = JSON.parse(response.body)
          expect(res['data']['attributes']['title']).to \
            eq(todo[:title])
        end
      end

      response '400', 'Missing Request parameters' do
        let(:todo) { {} }
        run_test! do |response|
          err = JSON.parse(response.body)
          expect(err['message']).to eq('param is missing or the value is empty: todo')
          expect(err['code']).to eq('400')
        end
      end

      response '422', 'Invalid Request' do
        let(:todo) { { title: '' } }

        run_test! do |response|
          resp = JSON.parse(response.body)
          expect(resp['message']).to eq('Validation failed')

          err = resp['errors'].first
          expect(err['resource']).to eq('Todo')
          expect(err['field']).to eq('title')
          expect(err['code']).to eq('422')
        end
      end
    end

    delete 'Delete a todo' do
      tags 'Todos'
      produces 'application/vnd.api+json'

      response '204', 'Successful Operation' do
        let(:todo) { Todo.create!(title: 'Test todo') }
        let(:id) { todo.id }
        run_test!
      end
    end
  end

  path '/todos' do
    post 'Creates a todo' do
      tags 'Todos'
      consumes 'application/json'
      produces 'application/vnd.api+json'

      parameter name: :todo, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string }
        },
        required: %w[title]
      }

      response '201', 'Successful Operation' do
        let(:todo) { { title: 'my foo' } }

        run_test! do |response|
          todo = Todo.last
          resp = JSON.parse(response.body)['data']
          expect(Integer(resp['id'])).to eq(todo.id)
          expect(resp['type']).to eq('todos')
          expect(resp['attributes']['title']).to eq(todo.title)
        end
      end

      response '422', 'Invalid Request' do
        let(:todo) { { title: '' } }

        run_test! do |response|
          resp = JSON.parse(response.body)
          expect(resp['message']).to eq('Validation failed')

          err = resp['errors'].first
          expect(err['resource']).to eq('Todo')
          expect(err['field']).to eq('title')
          expect(err['code']).to eq('422')
        end
      end

      response '400', 'Missing Request parameters' do
        let(:todo) { {} }
        run_test! do |response|
          err = JSON.parse(response.body)
          expect(err['message']).to eq('param is missing or the value is empty: todo')
          expect(err['code']).to eq('400')
        end
      end
    end
  end
end
