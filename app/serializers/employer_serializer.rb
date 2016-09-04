class EmployerSerializer < ActiveModel::Serializer
  attributes :id, :name, :label

  def label
    object.name
  end
end
