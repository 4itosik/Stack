require 'rails_helper'

describe Question do
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_presence_of :user }

  it { should validate_length_of(:title).is_at_least 15 }
  it { should validate_length_of(:title).is_at_most 150 }
  it { should validate_length_of(:body).is_at_least 30 }

  it { should belong_to :user }

  it { should have_many(:answers).dependent(:destroy) }

  it_should_behave_like "attachable"
  it_should_behave_like "voteable"
end
