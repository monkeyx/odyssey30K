class ProbabilityMatrix
  
  def self.test(first, second)
    (1..first).sum{d10} > (1..second).sum{d10}
  end
  
  VERY_EASY = 25
  EASY = 50
  DIFFICULT = 100
  VERY_DIFFICULT = 150
  IMPOSSIBLE = 200
  
  private
  
  def self.d10
    rand(10) + 1
  end
end