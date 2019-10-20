class SearchesController < ApplicationController
  skip_authorization_check
  skip_authorize_resource

  def search
    @results = Services::Search.new(search_params.to_h).call
  end

  private

  def search_params
    params.require(:search).permit(:search_type, :search_string)
  end
end
