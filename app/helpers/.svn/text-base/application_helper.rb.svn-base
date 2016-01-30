module ApplicationHelper
  
  def drachma(value)
    value.nil? ? "n/a" : "&#8367;&nbsp;#{value}"
  end
  def h_symbol(value)
    value.nil? ? h(value) : value.to_s.gsub('_',' ').titleize
  end
  
  def h_roman_numeral(value)
    if value.nil?
      h(value)
    elsif value.is_a?(Integer) || value.is_a?(Fixnum)
      r = Roman.new
      r.to_roman(value).upcase
    else
      h(value)
    end
  end
  
  def h_greek_number(value,height=14,width=12)
    if value.nil? || !value.is_a?(Integer) || !value.is_a?(Fixnum) || value < 1 || value > 1000
      h(value)
    else
      num = value.to_s
      i = num.length - 1
      power = 1
      outlit = ''
      while i >= 0 do
        digit = power * num[i..i+1].to_i
        outlit = "<img src=\"/images/greek/let#{digit}.gif\" height=\"#{height}\" width=\"#{width}\"/>#{outlit}"
        power *= 10
        i -= 1
      end
      outlit
    end
  end
  
  def options_from_symbols(symbols_array, allow_none=false)
    options = []
    options << ['None',''] if allow_none
    symbols_array.each do |value|
      options << [h_symbol(value),value.to_s]
    end
    options
  end
  
  def options_from_models(models, allow_none=false, name_field = :name)
    options = []
    options << ['None',''] if allow_none
    models.each do |value|
      options << [value.send(name_field),value.id]
    end
    options
  end
  
  def options_from_range(range, roman=false)
    options = []
    range.each do |value|
      display = roman ? h_roman_numeral(value) : value.to_s
      options << [display, value]
    end
    options
  end
  
  def radio_buttons_from_symbols(f, field, symbols_array)
    out = ''
    symbols_array.each do |value|
      out = "#{out}\n#{f.radio_button(field,value.to_s)}#{h_symbol(value)}"
    end
    out
  end

  def radio_buttons_from_range(f, field, range, greek=false)
    out = ''
    range.each do |value|
      display = greek ? h_greek_number(value) : value.to_s
      out = "#{out}\n#{f.radio_button(field,value.to_s)}#{display}"
    end
    out
  end
  
  def filter_form(filter_options)
    selector = select_tag('filter', 
                options_for_select(
                  options_from_symbols(filter_options), params[:filter]
                ),
               :onchange => "document.forms['filter_form'].submit();")
    "<form name=\"filter_form\" method=\"get\">\nFilter: #{selector}\n</form>"
  end
  
  def colony_filter_form(colonies = Colony.all)
    selector = select_tag('colony', 
                options_for_select(
                  options_from_models(colonies, true), [@colony.id]
                ),
               :onchange => "document.forms['colony_form'].submit();")
    "<form name=\"colony_form\" method=\"get\">\nColony: #{selector}\n</form>"
  end
  
  def market_filter_form
    colony_selector = select_tag('colony', 
                options_for_select(
                  options_from_models(Colony.all, true), [@colony ? @colony.id : 0]
                ),
               :onchange => "document.forms['colony_form'].submit();")
    item_selector = select_tag('filter', 
                options_for_select(
                  options_from_symbols(Item::ALLOWED_FILTERS), params[:filter]
                ),
               :onchange => "document.forms['colony_form'].submit();")
    type_selector = select_tag('buy_or_sell', 
                options_for_select(
                  options_from_symbols(['both', 'buy','sell']), params[:buy_or_sell]
                ),
               :onchange => "document.forms['colony_form'].submit();")
    "<form name=\"colony_form\" method=\"get\">\nColony: #{colony_selector} Item: #{item_selector} Type: #{type_selector}\n</form>"
  end
  
  def format_date(date=Time.zone.now,show_year=false)
    m = date.month
    m = m + 1 if date.day > 14
    m = 1 if m > 12
    d = date.day < 14 ? date.day + 14 : date.day - 14
    m_name = $MONTH_NAMES[m]
    s = "#{d.ordinalize} #{m_name}"
    s = s + ", 2#{(date.year - 2000).ordinalize} Olympiad" if show_year
    s
  end
  
  def format_number(number)
    sprintf(number.to_s, ".0f").gsub('.0','')
  end
  
  def activerecord_error_list(errors)
    error_list = '<ul class="error_list">'
    error_list << errors.collect do |e, m|
      "<li>#{e.humanize unless e == "base"} #{m}</li>"
    end.to_s << '</ul>'
    error_list
  end
end
