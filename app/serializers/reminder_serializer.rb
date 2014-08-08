class ReminderSerializer < ActiveModel::Serializer
  attributes :id, :client_id, :description, :name, :date
end
