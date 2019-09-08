class LinksController < ApplicationController
  def destroy
    @link= Link.find(params[:id])
    authorize! :destroy, @file
    @link.destroy
  end
end
