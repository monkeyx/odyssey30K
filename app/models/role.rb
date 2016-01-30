class Role < ActiveRecord::Base
  ROLES = ['freeman','citizen','senator']
  
  def self.zeus
    find_or_create_by_name('zeus')
  end
  
  def self.freeman
    find_or_create_by_name('freeman')
  end
  
  def self.citizen
    find_or_create_by_name('citizen')
  end
  
  def self.senator
    find_or_create_by_name('senator')
  end
end