require 'rails_helper'

describe Comment do
  it { should validate_presence_of :body }
  it { should validate_presence_of :user }
  it { should validate_presence_of :commentable }

  it { should validate_length_of(:body).is_at_least 3 }

  it { belong_to :user }
  it { belong_to :commentable }
end
