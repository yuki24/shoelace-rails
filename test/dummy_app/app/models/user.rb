class User
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :name
  attribute :description
  attribute :color
  attribute :score
  attribute :current_city
  attribute :previous_city
  attribute :past_cities
  attribute :remember_me
  attribute :subscribe_to_emails
end
