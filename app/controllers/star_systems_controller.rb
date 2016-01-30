class StarSystemsController < ApplicationController
  require_role 'zeus', :for_all_except => [:map, :show]
  require_role 'freeman', :for => [:map, :show]
  
  def map
    @current_coordinates = [0,0]
    if current_starship
      @current_coordinates = current_starship.current_galactic_coordinates
    end
    @map_bounds = StarSystem.map_bounds
    # shift map left if too right
    if @current_coordinates[0] - 50 < @map_bounds[0][0]
      @current_coordinates[0] = @map_bounds[0][0] + 25
    end
    # ... right if too left
    if @current_coordinates[0] + 50 > @map_bounds[0][1]
      @current_coordinates[0] = @map_bounds[0][1] - 25
    end
    # ... up if too down
    if @current_coordinates[1] - 20 < @map_bounds[1][0]
      @current_coordinates[1] = @map_bounds[1][0] + 10
    end
    # ... down if too up
    if @current_coordinates[1] + 20 > @map_bounds[1][1]
      @current_coordinates[1] = @map_bounds[1][1] - 10
    end
  end
  
  # GET /star_systems
  # GET /star_systems.xml
  def index
    filter = params[:filter] || 'all'
    filter = 'all' unless StarSystem::ALLOWED_FILTERS.include?(filter)
    
    @star_systems = StarSystem.send(filter.to_sym)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @star_systems }
    end
  end

  # GET /star_systems/1
  # GET /star_systems/1.xml
  def show
    @star_system = StarSystem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @star_system }
    end
  end

  # GET /star_systems/new
  # GET /star_systems/new.xml
  def new
    @star_system = StarSystem.new
    @clusters = Cluster.find(:all)
    @star_systems = StarSystem.find(:all, :order => 'name ASC')
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @star_system }
    end
  end

  # GET /star_systems/1/edit
  def edit
    @star_system = StarSystem.find(params[:id])
    @clusters = Cluster.find(:all)
    @star_systems = StarSystem.find(:all, :conditions => ['id <> ?', params[:id]], :order => 'name ASC')
  end

  # POST /star_systems
  # POST /star_systems.xml
  def create
    @star_system = StarSystem.new(params[:star_system])
    
    respond_to do |format|
      if @star_system.save
        format.html { redirect_to(@star_system, :notice => 'StarSystem was successfully created.') }
        format.xml  { render :xml => @star_system, :status => :created, :location => @star_system }
      else
        @clusters = Cluster.find(:all)
        @star_systems = StarSystem.find(:all, :order => 'name ASC')
        format.html { render :action => "new" }
        format.xml  { render :xml => @star_system.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /star_systems/1
  # PUT /star_systems/1.xml
  def update
    @star_system = StarSystem.find(params[:id])

    respond_to do |format|
      if @star_system.update_attributes(params[:star_system])
        format.html { redirect_to(@star_system, :notice => 'StarSystem was successfully updated.') }
        format.xml  { head :ok }
      else
        @clusters = Cluster.find(:all)
        @star_systems = StarSystem.find(:all, :conditions => ['id <> ?', @star_sytem.id], :order => 'name ASC')
        format.html { render :action => "edit" }
        format.xml  { render :xml => @star_system.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /star_systems/1
  # DELETE /star_systems/1.xml
  def destroy
    @star_system = StarSystem.find(params[:id])
    @star_system.destroy

    respond_to do |format|
      format.html { redirect_to(star_systems_url) }
      format.xml  { head :ok }
    end
  end
end
