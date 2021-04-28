class City < ApplicationRecord
  self.primary_key = :city_number
  has_many :offices
  belongs_to :prefecture
end
