class Industry
  def self.calculate_raw_materials(item)
    metals = Item.metals.first
    minerals = Item.minerals.first
    hydrocarbons = Item.hydrocarbons.first
    crystals = Item.crystals.first
    
    materials = {
    metals => 0,
    minerals => 0,
    hydrocarbons => 0,
    crystals => 0
    }
    
    if item.tough?
      materials[metals] += item.mass / 2
      materials[minerals] += item.mass / 2
    end
    if item.efficient?
      materials[hydrocarbons] += 4 * item.mass / 5
      materials[minerals] += item.mass / 5
    end
    if item.keen?
      materials[metals] += 3 * item.mass / 5
      materials[minerals] += item.mass / 5
      materials[crystals] += item.mass / 5
    end
    if item.stealthed?
      materials[minerals] += 2 * item.mass / 10
      materials[hydrocarbons] += 7 * item.mass / 10
      materials[crystals] += item.mass / 10
    end
   if item.specialized?
      materials[metals] += 2 * item.mass / 7
      materials[hydrocarbons] += 3 * item.mass / 7
      materials[minerals] += 2 * item.mass / 7
    end
    if item.accurate?
      materials[metals] += item.mass / 5
      materials[hydrocarbons] += 3 * item.mass / 5
      materials[crystals] += item.mass / 5
    end
    
    if item.compact?
      materials[metals] += item.mass / 5
      materials[minerals] += 3 * item.mass / 5
      materials[hydrocarbons] += item.mass / 5
    elsif item.luxurious?
      materials[metals] += 3 * item.mass / 12
      materials[hydrocarbons] += 8 * item.mass / 12
      materials[minerals] += item.mass / 12
    end
    
    if item.fast?
      materials[metals] += item.mass / 5
      materials[hydrocarbons] += 3 * item.mass / 5
      materials[crystals] += item.mass / 5
    end
    
    if item.high_energy?
      materials[metals] += item.mass / 5
      materials[crystals] += 3 * item.mass / 5
      materials[minerals] += item.mass / 5
    elsif item.low_energy?
      materials[metals] += item.mass / 5
      materials[hydrocarbons] += 3 * item.mass / 5
      materials[minerals] += item.mass / 5
    end
    
    materials[metals] = item.mass if materials[minerals] + materials[hydrocarbons] + materials[crystals] == 0
    
    materials
  end
  
end