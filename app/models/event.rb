class Event < ActiveRecord::Base
  validates_presence_of :user_id
  validates_numericality_of :user_id, :only_integer => true
  validates_presence_of :model_id
  validates_numericality_of :model_id, :only_integer => true
  validates_presence_of :model_class
  validates_presence_of :description
  
  default_value_for :major do
    false
  end
  
  named_scope   :major, :conditions => {:major => true}
  named_scope   :recent_events, :limit => 5, :order => 'id DESC'
  named_scope   :user, lambda {|user|
    {:conditions => {:user_id => user.id}}
  }
  
  named_scope   :for_model, lambda {|model|
    {:conditions => ['model_class = ? AND model_id = ?', model.class.name, model.id]}
  }
  
  def model
    return nil unless model_id && model_class
    c = Kernel.const_get(model_class)
    return nil unless c
    c.send(:find, model_id)
  end
  
  def model=(obj)
    return unless obj
    self.model_id = obj.id
    self.model_class = obj.class.name
  end
  
  def self.log!(user,model,description,major=false)
    Kernel.p "#{model} (#{user}):: #{description}" if major
    Event.create!(:user_id => user.id, :model_id => model.id, :model_class => model.class.name, :description => description, :major => major)
  end
  
end
