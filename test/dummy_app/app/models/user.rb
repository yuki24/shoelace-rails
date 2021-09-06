class User
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :name
  validates :name, presence: true
end
