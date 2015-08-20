require 'rails_helper'

describe Search do
  describe ".search" do
    let(:query) { "search" }
    let(:type) { "Answer" }

    it "query nil?" do
      expect(Search.search(nil)).to be_empty
    end

    it "search if type nil" do
      expect(ThinkingSphinx).to receive(:search).with(query)
      Search.search(query)
    end

    it "search with type" do
      expect(ThinkingSphinx).to receive(:search).with(query, classes: [type.constantize])
      Search.search(query, type)
    end
  end
end