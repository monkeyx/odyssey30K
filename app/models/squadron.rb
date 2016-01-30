class Squadron < ActiveRecord::Base
  validates_presence_of   :name
  validates_length_of     :name,    :maximum => 100

  validates_presence_of   :squadron_leader_id
  belongs_to              :squadron_leader,   :class_name => 'Starship'

  has_many                :starships
end
