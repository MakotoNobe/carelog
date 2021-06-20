class Api::V1::OfficesController < ApplicationController
  def index
    if params[:keyword]
      @offices = Office.page(params[:page]).per(10)
                .keyword(params[:keyword])
    else
      @offices = Office.page(params[:page]).per(10)
    end
    render json: { 'offices': @offices }
  end

  def show
  end
end
