class SearchsController < ApplicationController
  authorize_resource

  def index
    @searchs = Search.search(params[:query], params[:type])
  end
end
