class NotesController < ApplicationController
  def create
    @note = Note.new(note_params)
    @note.user = current_user
    if !(@note.save)
      flash[:errors] = @note.errors.full_messages
    end
    redirect_to track_url(@note.track_id)
  end
  
  def destroy
    note = Note.find(params[:id])
    if note.user_id != current_user.id
      render(json: "Forbidden", status: 403) and return
    end
    track = note.track_id
    note.destroy
    redirect_to track_url(track)
  end
  
  private
  
  def note_params
    params.require(:note).permit(:note, :user_id, :track_id)
  end
  
end
