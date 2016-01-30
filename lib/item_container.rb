module ItemContainer
  # these methods must be implemented by the class
  # cargo_capacity
  # ore_capacity
  # resource_capacity
  # life_capacity
  # stored_items - must be a collection of models with "item" and "quantity" properties
  # count_item(item) - must return an int 
  # get_stored_item(item) - returns model for given item with properties of "item" and "quantity"
  # add_item_knowledge! - adds knowledge to the owner of the position
  
  def store?
    (cargo_capacity + ore_capacity + resource_capacity + life_capacity) > 0
  end
  
  def cargo_space_used
    stored_items.to_a.sum{|item| (item.item.ore? || item.item.resource? || item.item.lifeform?) ? 0 : item.item.mass * item.quantity}
  end
  
  def ore_space_used
    stored_items.to_a.sum{|item| item.item.ore? ? item.item.mass * item.quantity : 0}
  end
  
  def resource_space_used
    stored_items.to_a.sum{|item| item.item.resource? ? item.item.mass * item.quantity : 0}
  end
  
  def life_space_used
    stored_items.to_a.sum{|item| item.item.lifeform? ? item.item.mass * item.quantity : 0}
  end
  
  def free_cargo_capacity
    cargo_capacity - cargo_space_used
  end
  
  def free_ore_capacity
    (ore_capacity - ore_space_used)
  end
  
  def free_resource_capacity
    (resource_capacity - resource_space_used)
  end
  
  def free_life_capacity
    life_capacity - life_space_used
  end
  
  def overcapacity?
    free_cargo_capacity < 0 || free_ore_capacity < 0 || free_resource_capacity < 0 || free_life_capacity < 0
  end
    
  def has_items?(items)
    items.each do |item, quantity|
      return false unless count_item(item) >= quantity
    end
    true
  end
  
  def space_for_item(item)
    (if item.lifeform?
      free_life_capacity / item.mass
    elsif item.ore?
      free_ore_capacity / item.mass
    elsif item.resource?
      free_resource_capacity / item.mass
    else
      free_cargo_capacity / item.mass
    end).to_i
  end
  
  def add_items!(item, quantity)
    return unless quantity && quantity > 0
    quantity = space_for_item(item) if quantity > space_for_item(item)
    stored_item = get_stored_item(item)
    stored_item.quantity += quantity
    stored_item.quantity = 0 if stored_item.quantity < 0
    stored_item.save!
    add_item_knowledge!(item)
    quantity
  end
  
  def remove_items!(item, quantity)
    stored_item = get_stored_item(item)
    return 0 unless stored_item && stored_item.quantity && quantity
    quantity = stored_item.quantity if stored_item.quantity < quantity
    total = stored_item.quantity - quantity
    stored_item.update_attributes!(:quantity => total)
    quantity
  end
  
  def remove_all_items!(items)
    items.each do |item, quantity|
      remove_items!(item, quantity)
    end
  end
  
  def use_raw_materials!(item, quantity)
    item.raw_materials.each do |rm, qty|
      remove_items!(rm, (qty * quantity))
    end
  end
end