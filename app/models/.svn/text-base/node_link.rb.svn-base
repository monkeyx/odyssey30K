class NodeLink < ActiveRecord::Base
  validates_presence_of     :from_star_system_id
  belongs_to                :from,  :foreign_key  => 'from_star_system_id',   :class_name => 'StarSystem'

  validates_presence_of     :to_star_system_id
  belongs_to                :to,  :foreign_key  => 'to_star_system_id',   :class_name => 'StarSystem'
end
