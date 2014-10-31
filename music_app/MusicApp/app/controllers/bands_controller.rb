class BandsController < ApplicationController
  before_action :require_logged_in
  def index
    @bands = Band.all
    render :index
  end
  
  def new
    render :new
  end
  
  def create
    band = Band.new(band_params)
    if band.save
      redirect_to band_url(band.id)
    else
      render :new
    end
  end
  
  def destroy
    @band = Band.find(params[:id])
    if @band.destroy
      redirect_to new_band_url
    else
      render :show
    end
  end
  
  def edit
    @band = Band.find(params[:id])
    render :edit
  end
  
  def update
    band = Band.find(params[:id])
    if band.update(band_params)
      redirect_to band_url(band.id)
    else
      render :edit
    end
  end
  
  def show
    @band = Band.find(params[:id])
    render :show
  end
  
  private
  def band_params
    params.require(:band).permit(:name)
  end
end
