require 'rails_helper'

describe Vote do
  it { should validate_presence_of  :like }
  it { should validate_presence_of  :user }
  it { should validate_presence_of  :voteable }

  it {  create(:vote)
        should validate_uniqueness_of(:user).scoped_to(:voteable_id, :voteable_type) }

  it { should belong_to :user }
  it { should belong_to :voteable }

  it { should validate_inclusion_of(:like).in_array([1, -1]) }
end
