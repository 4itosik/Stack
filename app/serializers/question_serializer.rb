class QuestionSerializer < QuestionInCollectionSerializer
  has_many  :attachments
  has_many  :comments
end
