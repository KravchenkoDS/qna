class LinksController < ApplicationController
  def destroy
    @link= Link.find(params[:id])
    unless current_user.author?(@link.linkable)
      return redirect_to root_path, alert: 'Access denided'
    end
    @link.destroy
  end
end
