json.vote do
  json.voteable_type @vote.voteable_type
  json.voteable_id @vote.voteable_id
end
json.total_votes @voteable.total_votes