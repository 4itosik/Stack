class Search < ActiveRecord::Base
  def self.search(query, type = nil)
    return [] unless query.present?
    return ThinkingSphinx.search(query) unless type.present?
    ThinkingSphinx.search(query, classes: [type.constantize])
  end
end