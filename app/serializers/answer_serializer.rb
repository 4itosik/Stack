class AnswerSerializer < AnswerInCollectionSerializer
  has_many  :attachments
  has_many  :comments
end
