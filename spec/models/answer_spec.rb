require 'rails_helper'

describe Answer do
  it { should validate_presence_of :body }
  it { should validate_presence_of :question }
  it { should belong_to :question }
  it { should validate_length_of(:body).is_at_least 30 }
  it { should validate_length_of(:body).is_at_most 350 }
  it { should belong_to :user }
  it { should validate_presence_of :user }
end