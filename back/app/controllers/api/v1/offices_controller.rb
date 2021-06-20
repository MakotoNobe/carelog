class OfficesController < ApplicationController
  def index
    if params[:keyword]
      @offices = Office.page(params[:page]).per(10)
                          .keyword(params[:keyword])
    else
      @offices = Office.page(params[:page]).per(10)
    end
    render json: offices
  end

  def show
  end
end
