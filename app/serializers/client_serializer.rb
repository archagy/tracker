class ClientSerializer < ActiveModel::Serializer
  attributes :id,:name, :last_name, :phone, :description, :reminders
end
