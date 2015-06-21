class AttachmentsController < ApplicationController
  before_action :load_attachment
  before_action :owner_attachment

  respond_to  :js

  def destroy
    @attachment.destroy
  end

  private
    def load_attachment
      @attachment = Attachment.find(params[:id])
    end

    def owner_attachment
      redirect_to root_url, notice: "Access denied" unless @attachment.attachable.user == current_user
    end
end
