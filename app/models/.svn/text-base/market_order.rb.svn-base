class MarketOrder < ActiveRecord::Base
  before_validation      :round_price
  after_save             :destroy_empty

  validates_presence_of   :user_id
  belongs_to              :user
  
  validates_presence_of   :colony_id
  belongs_to              :colony
  
  validates_presence_of   :item_id
  belongs_to              :item

  validates_numericality_of :buy_quantity, :only_integer => true, :greater_than_or_equal_to => 0
  default_value_for :buy_quantity, 0
  validates_numericality_of :sell_quantity, :only_integer => true, :greater_than_or_equal_to => 0
  default_value_for :sell_quantity, 0
  
  validates_numericality_of :price, :greater_than_or_equal_to => 0
  default_value_for         :price, 0
  
  def round_price
    self.price = self.price.round(2) if self.price
  end
  
  validates_presence_of     :destination_id,  :if => Proc.new{|mo| !mo.destination_model.nil? }
  validates_presence_of     :destination_model, :if => Proc.new{|mo| !mo.destination_id.nil? }
  
  def destination
    return nil unless destination_id && destination_model
    c = Kernel.const_get(destination_model)
    return nil unless c
    c.send(:find, destination_id)
  end
  
  def destination=(obj)
    return unless obj
    self.destination_id = obj.id
    self.destination_model = obj.class.name
  end
  
  def starship_destination?
    destination.is_a?(Starship)
  end
  
  def building_destination?
    destination.is_a?(Building)
  end
  
  attr_accessor :install_section
  attr_accessor :ship_crew
  
  def before_initialize
    @install_section = false
    @ship_crew = false
  end
  
  named_scope       :buying, :conditions => ['buy_quantity > 0'], :order => 'price DESC'
  named_scope       :selling, :conditions => ['sell_quantity > 0'], :order => 'price ASC'
  named_scope       :min_price, lambda {|price|
    { :conditions => ['ROUND(price,2) >= ROUND(?,2)',price]}
  }
  named_scope       :max_price, lambda {|price|
    { :conditions => ['ROUND(price,2) <= ROUND(?,2)',price]}
  }
  named_scope       :within_price, lambda {|low,high|
    { :conditions => ['ROUND(price,2) >= ROUND(?,2) AND ROUND(price,2) <= ROUND(?,2)',low,high]}
  }
  named_scope       :at_colony, lambda {|colony|
    { :conditions => {:colony_id => colony.id}}
  }
  named_scope       :of_item, lambda {|item|
    { :conditions => {:item_id => item.id}}
  }
  named_scope       :in_items, lambda {|items|
    { :conditions => ['item_id IN (?)',items.map{|i|i.id}]}
  }
  named_scope       :buying_or_selling, lambda {|buying_or_selling|
    { :conditions => 
        (buying_or_selling == 'buy' || buying_or_selling == 'both' ? "buy_quantity >= 0" : "buy_quantity = 0") +
        " AND " + 
        (buying_or_selling == 'sell' || buying_or_selling == 'both' ? "sell_quantity >= 0" : "sell_quantity = 0")
    }
  }
  
  named_scope       :for_sale, lambda {|colony, items|
    { :conditions => ['sell_quantity > 0 AND colony_id = ? AND item_id IN (?)',colony.id, items.map{|i|i.id}], :order => 'price ASC'}
  }
  
  named_scope       :want_to_buy, lambda {|colony, items|
    { :conditions => ['buy_quantity > 0 AND colony_id = ? AND item_id IN (?)',colony.id, items.map{|i|i.id}], :order => 'price DESC'}
  }
  def self.suggested_buy_price(colony, items)
    return items.to_a.sum{|i|i.raw_cost} * (2 + demand_level(colony, items)[0]).round.to_i
  end
  
  def self.suggested_sell_price(colony, items)
    return items.to_a.sum{|i|i.raw_cost} * (2 + demand_level(colony, items)[0]).round.to_i
  end

  def self.demand_level(colony, items)
    buy_calc = MarketOrder.find(:first, :select => ['SUM(buy_quantity) AS demand, AVG(price) AS mean_price'], :conditions => ['buy_quantity > 0 AND colony_id = ? AND item_id IN (?)',colony.id, items.map{|i| i.id}])
    sell_calc = MarketOrder.find(:first, :select => ['SUM(sell_quantity) AS demand, AVG(price) AS mean_price'], :conditions => ['sell_quantity > 0 AND colony_id = ? AND item_id IN (?)',colony.id, items.map{|i| i.id}])
    d1,m1,d2,m2 = 0,0,0,0
    d1,m1 = buy_calc.demand.to_f, buy_calc.mean_price.to_f if buy_calc.demand && buy_calc.mean_price
    d2,m2 = sell_calc.demand.to_f, sell_calc.mean_price.to_f if sell_calc.demand && sell_calc.mean_price
    i = if d1 == d2
      0
    elsif d1 == 0 # no buyers
      -1
    elsif d2 == 0 # no sellers
      1
    elsif d1 > d2 # more buyers than sellers
      (d2 * m2) / (d1 * m2)
    elsif d2 > d1 # more sellers than buyers
      0 - (d1 * m1) / (d2 * m2)
    end
    return i, d1,m1,d2,m2
  end
  
  def self.mean_buy_price(colony, items)
    raise "Colony cannot be null" if colony.nil?
    raise "Items cannot be null" if items.nil?
    raise "Items is not an array or record collection" if !items.respond_to?(:map)
    raise "Invalid items array" if items.first.nil?
    calc = MarketOrder.find(:first, :select => ['AVG(price) AS mean_price'], 
      :conditions => ['colony_id = ? AND item_id IN (?) AND buy_quantity > 0 AND (sell_quantity = 0 OR sell_quantity IS NULL)',
      colony.id, items.map{|i| i.id }])
    calc.mean_price ? (calc.mean_price.to_f).round(2) : nil
  end
  
  def self.mean_sell_price(colony, items)
    raise "Colony cannot be null" if colony.nil?
    raise "Items cannot be null" if items.nil?
    raise "Items is not an array or record collection" if !items.respond_to?(:map)
    raise "Invalid items array" if items.first.nil?
    calc = MarketOrder.find(:first, :select => ['AVG(price) AS mean_price'], 
      :conditions => ['colony_id = ? AND item_id IN (?) AND sell_quantity > 0 AND (buy_quantity = 0 OR buy_quantity IS NULL)',
      colony.id, items.map{|i| i.id }])
    calc.mean_price ? (calc.mean_price.to_f).round(2) : nil
  end

  def self.buy!(buyer, colony, items, quantity, max_price, create_buy_order = false, destination = nil, install_section = false, ship_crew = false)
    return false unless quantity > 0
    # try to find sellers
    qty_bought = {}
    for_sale(colony,items).max_price(max_price).each do |sell_order|
      item = sell_order.item
      qty_bought[item] = 0
      unless qty_bought[item] >= quantity || buyer.drachma < sell_order.price
        qty_to_buy = quantity - qty_bought[item]
        if destination
          if install_section && destination.is_a?(Starship)
            qty_to_buy = destination.can_add_sections(item) if qty_to_buy > destination.can_add_sections(item)
          elsif ship_crew && destination.is_a?(Starship)
            qty_to_buy = destination.can_hire_crew(item) if qty_to_buy > destination.can_hire_crew(item)
          else
            qty_to_buy = destination.space_for_item(item) if qty_to_buy > destination.space_for_item(item)
          end
        end
        qty_to_buy = sell_order.sell_quantity if sell_order.sell_quantity < qty_to_buy
        qty_to_buy = (buyer.drachma / sell_order.price).to_i if sell_order.price * qty_to_buy > buyer.drachma
        if sell_order.buy!(buyer, qty_to_buy)
          qty_bought[item] += qty_to_buy 
        end
      end
    end
    # no sellers? issue buy order
    items.each do |item| 
      qty = qty_bought[item] ? (quantity - qty_bought[item]) : quantity
      if qty > 0
        o = find(:first, :conditions => ["user_id = ? AND colony_id = ? AND item_id = ? AND destination_id = ? AND destination_model = ? AND buy_quantity >= 0", buyer.id, colony.id, item.id, destination.id, destination.class.name])
        o = new(:user_id => buyer.id, :colony_id => colony.id, :item_id => item.id, :buy_quantity => 0, :price => 0, :destination_id => destination.id, :destination_model => destination.class.name) unless o
        o.price = (((o.buy_quantity * o.price) + (qty * max_price)) / (o.buy_quantity + qty)).round(2)
        o.buy_quantity = (qty + o.buy_quantity)
        o.save!
        destination.log!("Buy order for #{o.buy_quantity} x #{o.item} at #{o.price}")
      end
    end if create_buy_order && destination && buyer.is_a?(User)
    if destination
      if install_section
        items.each do |item| 
          (1..qty_bought[item]).each{destination.add_section!(item)}
        end
      elsif ship_crew
        items.each do |item|
          destination.add_crew!(item, qty_bought[item])
        end
      else
        items.each do |item| 
          destination.add_items!(item, qty_bought[item])
        end
      end
    end
    if destination && qty_bought.values.sum > 0
      msg = qty_bought.keys{|i| "#{qty_bought[i]} #{i}"}
      destination.log!("Bought #{msg}")
    end
    qty_bought
  end
  
  def self.sell!(seller, colony, items, quantity, min_price, create_sell_order = true, source = nil, ship_crew = false)
    return false unless quantity > 0
    # try to find buyers
    qty_sold = {}
    want_to_buy(colony,items).min_price(min_price).each do |buy_order|
      item = buy_order.item
      qty_sold[item] = 0
      unless qty_sold[item] >= quantity || buy_order.user.drachma < buy_order.price || (source && source.count_item(item) < 1)
        qty_to_sell = qty_sold[item] ? quantity - qty_sold[item] : quantity
        if source
          if ship_crew
            qty_to_sell = source.count_crew(item) if qty_to_sell > source.count_crew(item)
          else
            qty_to_sell = source.count_item(item) if qty_to_sell > source.count_item(item)
          end
        end
        qty_to_sell = buy_order.buy_quantity if buy_order.buy_quantity < qty_to_sell
        qty_to_sell = (buy_order.user.drachma / buy_order.price).to_i if buy_order.price * qty_to_sell > buy_order.user.drachma
        if buy_order.sell!(seller, qty_to_sell)
          qty_sold[item] += qty_to_sell 
          buy_order.destination.add_items!(item, qty_to_sell)
        end
      end
    end
    # no buyers? issue sell order
    items.each do |item| 
      qty = qty_sold[item] ? (quantity - qty_sold[item]) : quantity
      if source
        if ship_crew
          available = source.count_crew(item)
        else
          available = source.count_item(item)
        end
        qty = available if qty > available
      end
      if qty > 0
        o = find(:first, :conditions => ["user_id = ? AND colony_id = ? AND item_id = ? AND sell_quantity >= 0 AND (destination_id = 0 OR destination_id IS NULL)", seller.id, colony.id, item.id])
        o = new(:user_id => seller.id, :colony_id => colony.id, :item_id => item.id, :sell_quantity => 0, :price => 0) unless o
        o.price = (((o.sell_quantity * o.price) + (qty * min_price)) / (o.sell_quantity + qty)).round(2)
        o.sell_quantity = (qty + o.sell_quantity)
        o.save!
        if source
          if ship_crew
            source.remove_crew!(item, qty)
          else
            source.remove_items!(item, qty)
          end
          source.log!("Sell order for #{o.sell_quantity} x #{o.item} at #{o.price}")
        end
      end
    end if create_sell_order
    items.each do |item| 
      sold = qty_sold[item] ? qty_sold[item] : 0
      if ship_crew
        source.remove_crew!(item, sold) if sold > 0
      else
        source.remove_items!(item, sold) if sold > 0
      end
    end if source
    if source && qty_sold.values.sum > 0
      msg = qty_sold.keys{|i| "#{qty_sold[i]} #{i}"}
      source.log!("Sold #{msg}")
    end
    qty_sold
  end
  
  def market_buy!
    MarketOrder.buy!(user, colony, [item], buy_quantity, price, building_destination?, destination, install_section.blank? ? false : install_section, ship_crew.blank? ? false : ship_crew)[item] || 0
  end
  
  def market_sell!
    MarketOrder.sell!(user, colony, [item], sell_quantity, price, true, destination, ship_crew.blank? ? false : ship_crew)[item] || 0
  end
  
  def buy!(buyer, quantity)
    total = sell_quantity - quantity 
    return false if total < 0 
    update_attributes!(:sell_quantity => total )
    raise "Holy shit user_id = #{user_id} but user is nil" if user.nil?
    # puts "buy!: #{buyer}, #{user}, #{quantity * price}"
    Money.cash_transaction!(buyer, user, quantity * price, "Bought #{quantity} x #{item} at #{colony}")
    true
  end
  
  def sell!(seller, quantity)
    total = buy_quantity - quantity 
    return false if total < 0 
    update_attributes!(:buy_quantity => total )
    Money.cash_transaction!(user, seller, quantity * price, "Sold #{quantity} x #{item} at #{colony}")
    true
  end

  def destroy_empty
    destroy if buy_quantity < 1 && sell_quantity < 1
  end
  
  def to_s
    if buy_quantity > 0
      "#{user} buying #{buy_quantity} of #{item} at #{colony} for #{price}"
    else
      "#{user} selling #{sell_quantity} of #{item} at #{colony} for #{price}"
    end
  end
end
