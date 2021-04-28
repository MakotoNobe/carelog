class Api::V1::CitiesController < ApplicationController
  def get
    areas = Area.all

    if params[:area_id]
      prefectures = Prefecture.where(area_id: params[:area_id])
      cities = City.where(prefecture_id: prefectures.first)
    elsif params[:prefecture_id]
      kantou = Area.find_by(name: '関東')
      prefectures = Prefecture.where(area_id: kantou)
      cities = City.where(prefecture_id: params[:prefecture_id])
    else
      kantou = Area.find_by(name: '関東')
      prefectures = Prefecture.where(area_id: kantou)
      tokyo = Prefecture.find_by(name: '東京都')
      cities = City.where(prefecture_id: tokyo)
    end

    render json: { 'areas': areas, 'prefectures': prefectures, 'cities': cities }
  end
end
