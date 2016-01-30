class Quotations
  attr_reader :quotes
  
  def initialize
    @quotes = []
  end
  
  def read_from_file(data_file)
    f = File.new data_file, 'r'
    while line = f.gets
      quotes << line.strip
    end
    f.close
  end
  
  def random
    @quotes.sort_by{rand}.first
  end
end