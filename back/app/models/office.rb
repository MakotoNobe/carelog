class Office < ApplicationRecord

  belongs_to :city, foreign_key: :city_number, primary_key: :city_number

  def self.keyword(keyword) #ここでのself.はOffice.を意味する
    where(['name LIKE ? OR address LIKE ? OR company LIKE ?',
            "%#{keyword}%","%#{keyword}%",   "%#{keyword}%"])
                  #検索とoffice_name,address, business_entityの部分一致を表示。#Office.は省略
  end

  # scope :search, -> (search_params) do
  #   area(search_params[:area])
  #     .prefecture(search_params[:prefecture])
  #     .cities(search_params[:cities])
  # end

  # scope :area,       -> (area)       { where('area_id LIKE ?'      , "%#{area}%")       if area.present? }
  # scope :prefecture, -> (prefecture) { where('prefecture_id LIKE ?', "%#{prefecture}%") if prefecture.present? }
  # scope :cities,     -> (cities)     { where('city_number LIKE ?'  , "%#{cities}%")     if cities.present? }

  def self.area(area) #ここでのself.はOffice.を意味する
    where(['area_id LIKE ?',"%#{area}%"])
  end

  def self.prefecture(prefecture) #ここでのself.はOffice.を意味する
    where(['prefecture_id LIKE ?',"%#{prefecture}%"])
  end

  def self.cities(cities) #ここでのself.はOffice.を意味する
    where(['city_number LIKE ?',"%#{cities}%"])
  end


end
