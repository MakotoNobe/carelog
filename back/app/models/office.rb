class Office < ApplicationRecord
  belongs_to :city, primary_key: :city_number
end
