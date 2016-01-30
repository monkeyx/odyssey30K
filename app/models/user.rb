require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken

  validates_presence_of     :login
  validates_length_of       :login,    :within => 3..40
  validates_uniqueness_of   :login
  validates_format_of       :login,    :with => Authentication.login_regex, :message => Authentication.bad_login_message

  validates_format_of       :name,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
  validates_length_of       :name,     :maximum => 100

  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message
  
  CHARACTER_TYPES = Role::ROLES
  
  def self.zeus
    find(:first, :conditions => {:login => 'Zeus'})
  end
  
  def has_role?(role_in_question)
    @_list ||= self.roles.collect(&:name)
    return true if @_list.include?("zeus")
    (@_list.include?(role_in_question.to_s) )
  end

  def activate_citizenship!(months = 1)
    self.roles << Role.citizen
    self.subscription_until = Time.zone.now.advance(:months => months)
    save!
    log_event!(self,"#{login} became a citizen.", true)
  end
  
  def activate_senator!(months = 1)
    self.roles << Role.senator
    self.subscription_until = Time.zone.now.advance(:months => months)
    save!
    log_event!(self,"#{login} became a senator.", true)
  end
  
  def zeus?
    has_role?("zeus")
  end
  
  def citizen?
    has_role?("citizen")
  end

  def senator?
    has_role?("senator")
  end
  
  def item_restriction
    zeus? ? "zeus" : senator? ? "senator" : citizen? ? "citizen" : "freeman"
  end
  
  def title
    return "Olympian" if zeus?
    return "Senator" if senator?
    return "Citizen" if citizen?
    "Freeman"
  end
  
  validates_numericality_of  :drachma,   :only_integer => true, :greater_than_or_equal_to => 0
  default_value_for          :drachma, 0
  
  has_many                   :starships, :foreign_key => 'captain_id'
  
  def starship_count
    @starship_count ||= self.starships.size
  end
  
  has_many                   :squadrons,  :foreign_key => 'squadron_leader_id'
  
  def squadron_count
    @squadron_count ||= self.squadrons.size
  end
  
  has_many                   :buildings,  :foreign_key => 'owner_id'
  
  def building_count
    @building_count ||= self.buildings.size
  end
  
  has_many                   :colonies,   :foreign_key => 'governor_id'
  
  def colony_count
    @colony_count ||= self.colonies.size
  end
  
  has_many                   :market_orders
  
  def market_order_count
    @market_order_count ||= self.market_orders.size
  end
  
  has_many                    :user_knowledges
  has_many                    :knowledges, :through => :user_knowledges
  
  def has_knowledge?(knowledge)
    knowledge && UserKnowledge.count("user_id = #{self.id} AND knowledge_id = #{knowledge.id}") > 0
  end
  
  def add_knowledge!(knowledge)
    self.user_knowledges.create!(:knowledge_id => knowledge.id) unless has_knowledge?(knowledge)
  end
  
  has_and_belongs_to_many :roles
  
  def authorized_for_item?(item_id)
    item = Item.find(item_id)
    return false unless item
    return false if item.senator_only? && !has_role?('senator')
    return false if item.citizen_only? && !has_role?('citizen')
    return true unless item.restricted?
    has_knowledge?(item.knowledge)
  end
  
  def authorized_for_starship?(starship_id)
    ship = Starship.find(starship_id)
    return false unless ship
    ship.captain == self
  end
  
  def authorized_for_building?(building_id)
    building = Building.find(building_id)
    return false unless building
    building.owner == self
  end
  
  named_scope                :active,   :conditions => 'activation_code IS NULL'
  
  def cash_log
    Money.cash_log(self)
  end
  
  def log_event!(model, description, major=false)
    Event.log!(self,model,description, major)
  end
  
  def event_log
    Event.find(:all, :conditions => ["user_id = ? OR major=1", self.id])
  end
  
  def to_s
    login
  end

  before_create :make_activation_code 

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :name, :password, :drachma, :character_type, :password_confirmation


  # Activates the user in the database.
  def activate!(do_setup=true)
    @activated = true
    self.activated_at = Time.now.utc
    self.activation_code = nil
    self.roles << Role.freeman
    save(false)
    setup! if do_setup
  end

  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end

  def active?
    # the existence of an activation code means they have not activated yet
    activation_code.nil?
  end
  
  def recently_activated?
    @activated
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(email, password)
    return nil if email.blank? || password.blank?
    u = find :first, :conditions => ['email = ? and activated_at IS NOT NULL', email] # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end

  protected
      def make_activation_code
    
        self.activation_code = self.class.make_token
      end
  
  
  # sets up new player position
  public
  SEED_FUND = 5000
  
  def setup!
    transaction do
      ship = Starship.build_ship!(Colony.random_starting_colony, Item.chassis.named("Galley").first, self)
      ship.add_section!(Item.command.named("Standard Bridge").first)
      ship.add_section!(Item.mission.named("Cargo Deck").first)
      ship.add_section!(Item.mission.named("Quarters").first)
      ship.add_section!(Item.engine.named("Solar Sail").first)
      ship.required_crew.each do |lifeform, quantity|
        ship.add_crew!(lifeform,quantity.to_i)
      end
      Money.cash_transaction!(User.zeus, self, SEED_FUND, "Initial seed fund")
      log_event!(self, "#{login} became a freeman.",true)
    end
  end
end
