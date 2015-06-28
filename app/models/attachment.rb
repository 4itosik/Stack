class Attachment < ActiveRecord::Base
  belongs_to :attachable, polymorphic: true

  validates :file, presence: true

  after_destroy :delete_files

  mount_uploader :file, FileUploader

  private
    def delete_files
      FileUtils.remove_dir("public/uploads/attachment/file/#{id}")
    end
end
