require 'rails_helper'

describe CommentsController do
  login_user

  %w(question answer).each do |parent|
    describe "#{parent}" do
      let(:commentable) { create(parent) }

      describe "GET #new" do
        before { xhr :get, :new, commentable: commentable.class.to_s.downcase.pluralize,
                     "#{commentable.class.to_s.downcase}_id": commentable }

        it "assigns a new Comment fot @question" do
          expect(assigns(:commentable).comments.first).to be_a_new(Comment)
        end

        it "render new view" do
          expect(response).to render_template :new
        end
      end

      describe "POST #create" do

        context "with valid attributes" do
          before(:each) { |ex| post :create, commentable: commentable.class.to_s.downcase.pluralize,
                                    "#{commentable.class.to_s.downcase}_id": commentable,
                                    comment: attributes_for(:comment), format: :js unless ex.metadata[:skip] }

          it "save new comment", skip_before: true do
            expect { post :create, commentable: commentable.class.to_s.downcase.pluralize,
                          "#{commentable.class.to_s.downcase}_id": commentable,
                          comment: attributes_for(:comment), format: :js }.to change(commentable.comments, :count).by(1)
          end

          it "render create" do
            expect(response).to render_template :create
          end

          it "add question to user" do
            expect(assigns(:comment).user).to eq @user
          end
        end

        context "with invalid attributes" do
          it "not save comment" do
            expect { post :create, commentable: commentable.class.to_s.downcase.pluralize,
                          "#{commentable.class.to_s.downcase}_id": commentable,
                          comment: attributes_for(:invalid_comment), format: :js }.to_not change(commentable.comments, :count)
          end

          it "re-render form" do
            post :create, commentable: commentable.class.to_s.downcase.pluralize,
                 "#{commentable.class.to_s.downcase}_id": commentable,
                 comment: attributes_for(:invalid_comment), format: :js
            expect(response).to render_template :create
          end
        end

      end
    end
  end

end
