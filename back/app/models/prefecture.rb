class Prefecture < ApplicationRecord
  belongs_to :area
  has_many :cities
end
