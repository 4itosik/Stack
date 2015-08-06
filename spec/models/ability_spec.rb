require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe "for guest" do
    let(:user) { nil }

    %w(question answer comment).each do |model|
      it { should be_able_to  :read, model.classify.constantize }
    end

    it { should be_able_to  :confirm, Authorization }
    it { should_not be_able_to :manage, :all }
  end

  describe "for admin" do
    let(:user) { create(:admin) }

    it { should be_able_to  :manage, :all }
  end

  describe "for user" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    it { should be_able_to  :read, :all }
    it { should be_able_to  :confirm, Authorization }

    it { should_not be_able_to :manage, :all }

    %w(question answer).each do |model|
      context "#{model.classify}" do
        let(:resource) { create(model.to_sym, user: user) }
        let(:resource_other) { create(model.to_sym, user: other_user) }

        it { should be_able_to :crud, resource, user: user }
        it { should_not be_able_to :crud, resource_other, user: user }

        context "Attachment" do
          let(:attachment) { create(:attachment, attachable: resource) }
          let(:attachment_other) { create(:attachment, attachable: resource_other) }

          it { should be_able_to :manage, attachment, user: user }
          it { should_not be_able_to :manage, attachment_other, user: user }
        end

        context "Vote" do
          let(:vote) { create(:vote, user: other_user, voteable: resource) }
          let(:other_vote) { create(:vote, user: user, voteable: resource_other) }

          it { should be_able_to :vote, resource_other, user: user }
          it { should_not be_able_to  :vote, resource, user: user}
          it { other_vote
            should_not be_able_to :vote, resource_other, user: user }

          it { other_vote
            should be_able_to :cancel_vote, resource_other, user: user }

          it { should_not be_able_to :cancel_vote, resource_other, user: user }
        end
      end
    end

    context "best answer" do
      let(:question) { create(:question, user: user) }
      let(:answer) { create(:answer, question: question) }
      let(:other_answer) { create(:answer) }

      it { should be_able_to :best, answer, user: user }
      it { should_not be_able_to :best, other_answer, user: user }
    end

    context "cancel_best answer" do
      let(:question) { create(:question, user: user) }
      let(:answer_best) { create(:best, question: question) }
      let(:other_answer) { create(:answer) }

      it { should be_able_to :cancel_best, answer_best, user: user }
      it { should_not be_able_to :cancel_best, other_answer, user: user }
    end

    it { should be_able_to :create, Comment }

    it { should be_able_to  :manage, :profile }
  end
end
