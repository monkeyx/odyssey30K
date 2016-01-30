##########################################################
# Roman Numeral converter -- By Sam Kellett
#
# Examples:
# r = Roman.new
# r.to_int "viii" # 8
# r.to_int "mcmxcix" # 1999
# r.viii # 8
# r.mcmxcix # 1999
# r.to_roman 2550 # "mmdl"
# r.to_roman 9 # "ix"
# 2550.to_roman # "mmdl"
#
# Supports: 
#  Rules regarding Roman numerals often state that a symbol representing 10x may not
#  precede any symbol larger than 10x+1. For example, C cannot be preceded by I or V, 
#  only by X (or, of course, by a symbol representing a value equal to or larger than 
#  C). Thus, one should represent the number "ninety-nine" as XCIX, not as the 
#  "shortcut" IC.
#    -- Wikipedia (http://en.wikipedia.org/wiki/Roman_numerals#XCIX_or_IC.3F)
#
#
# To-do:
#  - Basic arithmetic with roman numerals
#  - Integration with the Time and Date objects

class Roman
  VALUES = ["i", "v", "x", "l", "c", "d", "m"]
  NUMERAL = {
    "i" => 1,
    "v" => 5,
    "x" => 10,
    "l" => 50,
    "c" => 100,
    "d" => 500,
    "m" => 1000
  }
  SHORTCUTS = {
    "cm" => "dcccc",
    "ld" => "ccccl",
    "xc" => "lxxxx",
    "vl" => "xxxxv",
    "ix" => "viiii",
    "iv" => "iiii"
  }
  def to_int(str)
    total = 0
    str.downcase!
    return unless str =~ /^[mcdlxvi]+$/
    
    str.gsub! Regexp.compile(SHORTCUTS.keys.join("|")) do
      SHORTCUTS[$&]
    end

    str.split("").each do |char|
      total += NUMERAL[char]
    end
    total
  end
  
  def to_roman(int)
    numbers = reverse_hash NUMERAL
    longcuts = reverse_hash SHORTCUTS
    #return "bad" unless int =~ /^[0-9]+$/
    roman = ""
    
    mknum = []
    remainder = int.to_i
    numbers.keys.sort.reverse.each do |num|
      tmp = remainder.divmod num
      mknum.push tmp[0]
      remainder = tmp[1]
    end
    values = VALUES.reverse
    mknum.each_with_index do |num, i|
      roman << values[i]*num
    end
    roman.gsub! Regexp.compile(longcuts.keys.join("|")) do
      longcuts[$&]
    end
    roman
  end
  
  private
    def reverse_hash(hsh)
      tmp = {}
      hsh.each do |key, value|
        tmp[value] = key
      end
      tmp
    end
    def method_missing(method_id)
      to_int(method_id.id2name)
    end
end

class Integer
  def to_roman
    r = Roman.new
    r.to_roman(self)
  end
end