class ColonistKnowledge < ActiveRecord::Base
  validates_presence_of   :colonist_id
  belongs_to              :colonist
  
  validates_presence_of   :knowledge_id
  belongs_to              :knowledge
end
