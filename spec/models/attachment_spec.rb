require 'rails_helper'

describe Attachment do
  it { should validate_presence_of :file }

  it { should belong_to :attachable }

  it "#delete_files" do
    attachment = create(:attachment).destroy
    expect(File.exists?(attachment.file.path)).to be_falsey
  end
end
