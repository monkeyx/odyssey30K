class Money < ActiveRecord::Base
  validates_numericality_of :sender_id, :only_integer => true
  validates_numericality_of :receiver_id, :only_integer => true
  validates_presence_of :sender_id, :if => Proc.new{|m| m.sender_model }
  validates_presence_of :receiver_id, :if => Proc.new{|m| m.receiver_model }
  validates_presence_of :sender_model, :if => Proc.new{|m| m.sender_id }
  validates_presence_of :receiver_model, :if => Proc.new{|m| m.receiver_id }
  validates_numericality_of :amount
  validates_presence_of :reason
  
  def sender
    fetch_model(sender_model, sender_id)
  end
  
  def receiver
    fetch_model(receiver_model, receiver_id)
  end
  
  def self.cash_transaction!(sender, receiver, amount, reason)
    return false if sender.nil? || receiver.nil? || amount.nil?
    amount = amount.round.to_i
    receiver_total = (receiver.drachma + amount)
    sender_total = (sender.drachma - amount)
    return false unless sender_total >= 0
    if receiver.update_attributes!(:drachma => receiver_total) && sender.update_attributes!(:drachma => sender_total)
      create!(:sender_id => sender.id, :receiver_id => receiver.id, :sender_model => sender.class.name, :receiver_model => receiver.class.name, :amount => amount, :reason => reason)
      return true
    end
    false
  end
  
  def self.cash_log(model)
    find(:all, :conditions => ["(sender_id = ? AND sender_model = ?) OR (receiver_id = ? AND receiver_model = ?)", model.id, model.class.name, model.id, model.class.name], :limit => 20, :order => 'created_at DESC')  
  end
  
  private
  def fetch_model(model_class_name, model_id)
    return nil unless model_id && model_class_name
    c = Kernel.const_get(model_class_name)
    return nil unless c
    c.send(:find, model_id)
  end
end
