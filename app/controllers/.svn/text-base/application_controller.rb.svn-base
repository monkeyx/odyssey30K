# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  # You can move this into a different controller, if you wish.  This module gives you the require_role helpers, and others.
  include RoleRequirementSystem


  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  # include the title_helper
  helperful :title
  helperful :content
  
  def current_starship_id
    return nil unless current_user || !current_user.starships.any?
    session[:current_ship_id] ||= current_user.starships.first.id
  end
  
  def current_starship
    @current_starship ||= Starship.find(current_starship_id) if current_starship_id
  end
  
  def current_starship=(ship)
    session[:current_ship_id] = ship.nil? ? nil : ship.id
    @current_starship = ship
  end
  
  def current_building_id
    return nil unless current_user || !current_user.buildings.any?
    session[:current_building_id] ||= current_user.buildings.first.id
  end
  
  def current_building
    @current_building ||= Building.find(current_building_id) if current_building_id 
  end
  
  def current_building=(building)
    session[:current_building_id] = building.nil? ? nil : building.id
    @current_building = building
  end
  
  def current_colony_id
    return nil unless current_user || !current_user.colonies.any?
    session[:current_colony_id] ||= current_user.colonies.first.id
  end
  
  def current_colony
    @current_colony ||= Colony.find(current_colony_id) if current_colony_id 
  end
  
  def current_colony=(colony)
    session[:current_colony_id] = colony.nil? ? nil : colony.id
    @current_colony = colony
  end
  
  def activerecord_error_list(errors)
    error_list = '<ul class="error_list">'
    error_list << errors.collect do |e, m|
      "<li>#{e.humanize unless e == "base"} #{m}</li>"
    end.to_s << '</ul>'
    error_list
  end
end
