class Api::V1::OfficesController < ApplicationController
  def index
    if params[:keyword]
      @offices = Office.page(params[:page]).per(30)
                .keyword(params[:keyword])
    elsif params[:cities]
      @offices = Office.page(params[:page]).per(30)
                .cities(params[:cities])
    else
      @offices = Office.page(params[:page]).per(30)
    end
    render json: { 'offices': @offices }
  end

  def show
  end
end
