class AlbumsController < ApplicationController
  def create
    @album = Album.new(album_params)
    if @album.save
      redirect_to album_url(@album.id)
    else
      @bands = Band.all
      render :new
    end
  end
  
  def new
    @album = Album.new
    @album.band_id = params[:band_id]
    @bands = Band.all
    render :new
  end

  def show
    @album = Album.find(params[:id])
    render :show
  end
  
  def edit
    @album = Album.find(params[:id])
    @bands = Band.all
    render :edit
  end
  
  def update
    @album = Album.find(params[:id])
    if @album.update(album_params)
      redirect_to band_url(@album.band_id)
    else
      @bands = Band.all
      render :edit
    end
  end
  
  def destroy
    @album = Album.find(params[:id])
    if @album.destroy
      redirect_to bands_url
    else
      render :show
    end
  end
  
  private
  def album_params
    params.require(:album).permit(:name, :band_id, :live)
  end
end
