class Office < ApplicationRecord

  belongs_to :city, foreign_key: :city_number, primary_key: :city_number

  def self.keyword(keyword) #ここでのself.はOffice.を意味する
    keywords = keyword.split(/[[:blank:]]+/)
    keywords.map do |keyword|
      where('name LIKE ? OR address LIKE ? OR company LIKE ?',
              "%#{keyword}%","%#{keyword}%",   "%#{keyword}%")
                    #検索とoffice_name,address, business_entityの部分一致を表示。#Office.は省略
    end
  end

  # scope :search, -> (search_params) do
  #   area(search_params[:area])
  #     .prefecture(search_params[:prefecture])
  #     .cities(search_params[:cities])
  # end

  # scope :area,       -> (area)       { joins(city: :prefecture).where("area_id = ?", "#{area}") }
  # scope :prefecture, -> (prefecture) { joins(:city).where("prefecture_id = ?",  "#{prefecture}") }
  # scope :cities,     -> (cities)     { where("offices.city_number IN (?)", cities) }

  def self.area(area) #ここでのself.はOffice.を意味する
    joins(city: :prefecture).where("area_id = ?", "#{area}")
  end

  def self.prefecture(prefecture) #ここでのself.はOffice.を意味する
    joins(:city).where("prefecture_id = ?",  "#{prefecture}")
  end

  def self.cities(cities) #ここでのself.はOffice.を意味する
    where("offices.city_number IN (?)", cities)
  end

end
