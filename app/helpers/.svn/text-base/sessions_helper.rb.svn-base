module SessionsHelper
  def current_starship_id
    return nil unless current_user || !current_user.starships.any?
    session[:current_ship_id] ||= current_user.starships.first.id
  end
  
  def current_starship
    begin
      Starship.find(current_starship_id) if current_starship_id
    rescue
       session[:current_ship_id] = nil
       Starship.find(current_starship_id) if current_starship_id
    end
  end
  
  def current_building_id
    return nil unless current_user || !current_user.buildings.any?
    session[:current_building_id] ||= current_user.buildings.first.id
  end
  
  def current_building
    begin
      Building.find(current_building_id) if current_building_id 
    rescue
       session[:current_building_id] = nil
       Building.find(current_building_id) if current_building_id 
    end
  end
  
  def current_colony_id
    return nil unless current_user || !current_user.colonies.any?
    session[:current_colony_id] ||= current_user.colonies.first.id
  end
  
  def current_colony
    begin
      Colony.find(current_colony_id) if current_colony_id 
    rescue
       session[:current_colony_id] = nil
       Colony.find(current_colony_id) if current_colony_id 
    end
  end
end