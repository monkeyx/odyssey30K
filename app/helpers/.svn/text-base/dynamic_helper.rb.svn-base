module DynamicHelper
  def item_link(title, item)
    link_to title, item, :class => 'item-link'  
  end
  
  def toolbar_dock_at_colonies(starship)
    options = []
    starship.star_system.bodies.each do |body| 
      unless body == starship.celestial_body || body.colony.nil?
        energy_cost = starship.energy_cost_thrust_move(body) + starship.energy_cost_take_off_or_land
        title = "#{body.colony.name} [#{energy_cost}E]"
        url = "#{starship_path(starship)}/dock?colony=#{body.colony.id}"  
        options << [title,url]
      end
    end
    toolbar_select_item('Move and dock at', options, 'Dock')
  end

  def toolbar_move_to_planets(starship)
    options = []
    starship.star_system.bodies.each do |body| 
      unless body == starship.celestial_body
        title = "#{body.name} [#{starship.energy_cost_thrust_move(body)}E]"
        url = "#{starship_path(starship)}/thrust_move?body=#{body.id}"  
        options << [title,url]
      end
    end
    toolbar_select_item('Move to orbit of', options, 'Go')
  end
  
  def toolbar_select_item(name, options, submit_button = 'Go', id="toolbar-#{name.downcase.gsub(' ', '-')}")
    options_html = ''
    options.each{|option| options_html = "#{options_html}<option value='#{option[1]}'>#{option[0]}</option>"}
    content_for :toolbar_jquery do
      "$(document).ready(function() {
        $('\##{id}-button').click(function() {
          location.href = $('\##{id} option:selected').val();
        });   
      });"  
    end
    "<li>
    #{name}<select name='#{name}' id='#{id}' class='url-selector'>
      #{options_html}
    </select>
    <button id='#{id}-button'>#{submit_button}</button>
    </li>
    "
  end
  
  def toolbar_item(text,link,id="toolbar-#{text.downcase.gsub(' ','-')}")
    "<li>#{link_to(text,link, :id => id)}</li>"
  end
  
  def toolbar_form_item(text,link,id="toolbar-#{text.downcase.gsub(' ','-')}")
    content_for :toolbar_jquery do
      "$(document).ready(function() {
        $('\##{id}').colorbox({onClosed:function(){parent.location.reload();}});        
      });"  
    end
    toolbar_item(text,link,id)
  end
  
  def hideable_section(title, section_id=title.downcase.gsub(' ','-'), start_hidden=true)
    link_option = start_hidden ? "[Show]" : "[Hide]"
    content_for :hideable_section_jquery do
    "$(document).ready(function() {
      $('\##{section_id} .section-content').#{(start_hidden ? 'hide' : 'show')}();
      $('\#hideable-menu-#{section_id}').click(function(e){
        if($('\##{section_id} .section-content').is(':visible')) {
          $('\#hideable-menu-#{section_id}').html('[Show]');
          $('\##{section_id} .section-content').hide();
        }
        else {
          $('\#hideable-menu-#{section_id}').html('[Hide]');
          $('\##{section_id} .section-content').show();
        }
      });
    });"
    end
    "<div id='#{section_id}'>\n<h2>\n#{title}\n<span class='right section-menu' id='hideable-menu-#{section_id}'>#{link_option}</span>\n</h2>\n<div class='section-content'>\n#{yield}\n</div>\n</div>\n"
  end
end