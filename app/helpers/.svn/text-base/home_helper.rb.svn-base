module HomeHelper
  
  def scanned_starship(starship)
    desc = "#{starship.name} (#{link_to_user(starship.captain)})"
    if starship.attackable?(current_starship)
      desc = desc + link_to("[ATTACK!]", "#{starship_path(current_starship)}/attack?starship=#{starship.id}")
    end
    if starship.attackable?(current_starship,true)
      desc = desc + link_to("[BOARD!]", "#{starship_path(current_starship)}/board?starship=#{starship.id}")
    end 
    Kernel.p "!!! #{desc} !!!" 
    desc
  end
  
  def render_block(header_symbol, body_symbol)
    render :partial => "/block", :locals => {:header_symbol => header_symbol, :body_symbol => body_symbol}
  end
    
  def starship_location(starship)
    "#{starship.location_status} #{link_to starship.location.name, starship.location} in the #{link_to starship.star_system.name, starship.star_system} system"
  end
  
  def menu_item(title, href, subitems = {})
    clazz = request.request_uri.match(/^#{href}/) ? "active" : ""
    clazz = "" if href == "/" && request.request_uri != "/"
    clazz = "active" if href == "/map" && (request.request_uri.match(/^\/star_systems/) || request.request_uri.match(/^\/celestial_bodies/))
    link_to "<span><span>#{title}</span></span>", href, :title => title, :class => clazz
  end
  
  def star_image(star_system, options = {})
    image_tag("star_types/#{star_system.star_type}.png", options)
  end
  
  def galaxy_map(origin_x=0, origin_y=0, height = 20, width = 50)
    map = "<table id=\"galaxy-map\">\n"
    max_y = (origin_y + height / 2)
    min_x = (origin_x - width / 2)
    star_grid = StarSystem.star_grid
    (0..height).each do |row_id|
      y = (max_y) - row_id
      map = map + "<tr>\n"
      (0..width).each do |col_id|
        x = (min_x) + col_id
        ss = star_grid[x] ? star_grid[x][y] : nil
        map = map + "<td>\n"
        if ss
          title = "#{ss.name} (#{ss.x},#{ss.y})"
          map = map + link_to(star_image(ss, :alt => title, :title => title, :width => 50), ss) 
        else
          map = map + "&nbsp;\n"
        end
        map = map + "</td>\n"
      end
      map = map + "</tr>\n"
    end
    map = map + "</table>\n"
    map
  end
  
  def star_map(star_system)
    
  end
end
