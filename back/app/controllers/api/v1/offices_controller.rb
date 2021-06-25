class Api::V1::OfficesController < ApplicationController
  def index
    if params[:keyword]
      @offices = Office.page(params[:page]).per(5)
                .keyword(params[:keyword])
    elsif params[:area] && params[:prefecture] && params[:cities]
      @offices = Office.page(params[:page]).per(5)
                .area(params[:area])
                .prefecture(params[:prefecture])
                .cities(params[:cities])
    else
      @offices = Office.page(params[:page]).per(5)
    end
    render json: { 'offices': @offices }
  end

  def show
  end
end
