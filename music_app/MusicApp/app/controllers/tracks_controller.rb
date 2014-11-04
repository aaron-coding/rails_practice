class TracksController < ApplicationController
  before_action :require_logged_in
  def create
    @track = Track.new(track_params)
    if @track.save
      redirect_to track_url(@track.id)
    else
      @albums = Album.all
      render :new
    end
  end
  
  def edit
    @track = Track.find(params[:id])
    @albums = Album.all
    render :edit
  end
  
  def new
    @track = Track.new
    @track.album_id = params[:album_id]
    @albums = Album.all
    render :new
  end
  
  def show
    @track = Track.find(params[:id])
    render :show
  end
  
  def update
    @track = Track.find(params[:id])
    if @track.update(track_params)
      redirect_to track_url(@track.id)
    else
      @albums = Album.all
      render :edit
    end
  end
  
  def destroy
    @track = Track.find(params[:id])
    if @track.destroy
      redirect_to bands_url
    else
      render :show
    end
  end
  
  
  private
  
  def track_params
    params.require(:track).permit(:name, :album_id, :bonus, :lyrics)
  end
    
end
