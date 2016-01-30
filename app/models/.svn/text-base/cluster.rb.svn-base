class Cluster < ActiveRecord::Base
  validates_presence_of   :name
  validates_length_of     :name,    :maximum => 100
  
  default_value_for       :restricted, false
  
  def restrict!
    update_attributes!(:restricted => true)
  end
  
  has_many                :systems,   :class_name => 'StarSystem'
end
