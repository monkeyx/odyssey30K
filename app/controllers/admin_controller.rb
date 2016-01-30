class AdminController < ApplicationController
  require_role 'zeus'
  
  def index
  end

end
