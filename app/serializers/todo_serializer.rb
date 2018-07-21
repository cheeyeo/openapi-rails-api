class TodoSerializer < ActiveModel::Serializer
  attributes :id, :title
  link(:self) { api_v1_todo_url(object) }
end
