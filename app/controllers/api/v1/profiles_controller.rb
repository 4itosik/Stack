class Api::V1::ProfilesController < Api::V1::BaseController
  authorize_resource class: false

  def me
    respond_with current_resource_owner
  end

  def index
    respond_with @users = User.where.not(id:  current_resource_owner)
  end
end