class Api::V1::OfficesController < ApplicationController
  def index
    if params[:keyword]
      @offices = Office.page(params[:page]).per(30)
                .keyword(params[:keyword])
    elsif params[:area] && params[:prefecture] && cities_params
      @offices = Office.page(params[:page]).per(30)
                .area(params[:area])
                .prefecture(params[:prefecture])
                .cities(cities_params)
    else
      @offices = Office.page(params[:page]).per(30)
    end
    render json: { 'offices': @offices }
  end

  def show
  end

  private
  def cities_params
    params.require(:cities).permit(cities: [])
  end

end
