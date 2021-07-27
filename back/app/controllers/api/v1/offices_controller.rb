class Api::V1::OfficesController < ApplicationController
  def index
    if params[:keyword]
      @offices = Office.page(params[:page]).per(30)
                .keyword(params[:keyword])
    elsif params[:area] && params[:prefecture] && params[:cities]
      @offices = Office.page(params[:page]).per(30)
                .area(params[:area])
                .prefecture(params[:prefecture])
                .cities(params[:cities])
    else
      @offices = Office.page(params[:page]).per(30)
    end
    render json: { 'offices': @offices }
  end

  def show
    @office = Office.find_by(id: params[:id])
    render json: { 'office': @office }
  end

  def edit
    @office = Office.find_by(id: params[:id])
  end

  def destroy
    @office = Office.find_by(id: params[:id])
    @office.destroy
    render json: {'office': @office}
  end
  
end
