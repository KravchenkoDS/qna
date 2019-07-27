class FilesController < ApplicationController
  def destroy
    @file = ActiveStorage::Attachment.find(params[:id])
    unless current_user.author?(@file.record)
      return redirect_to root_path, alert: 'Access denided'
    end
    @file.purge
  end

end
