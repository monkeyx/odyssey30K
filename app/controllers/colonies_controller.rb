class ColoniesController < ApplicationController
  require_role 'zeus', :for_all_except => [:show]
  require_role 'freeman', :for => [:show]
  
  # GET /colonies
  # GET /colonies.xml
  def index
    @colonies = Colony.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @colonies }
    end
  end

  # GET /colonies/1
  # GET /colonies/1.xml
  def show
    @colony = Colony.find(params[:id])
    self.current_colony = @colony
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @colony }
    end
  end

  # GET /colonies/new
  # GET /colonies/new.xml
  def new
    @colony = Colony.new
    @celestial_bodies = CelestialBody.habitable.unoccupied
    @users = User.active
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @colony }
    end
  end

  # GET /colonies/1/edit
  def edit
    @colony = Colony.find(params[:id])
    @celestial_bodies = CelestialBody.habitable.unoccupied
    @users = User.active
  end

  # POST /colonies
  # POST /colonies.xml
  def create
    @colony = Colony.new(params[:colony])

    respond_to do |format|
      if @colony.save
        format.html { redirect_to(@colony, :notice => 'Colony was successfully created.') }
        format.xml  { render :xml => @colony, :status => :created, :location => @colony }
      else
        @celestial_bodies = CelestialBody.habitable.unoccupied
        @users = User.active
        format.html { render :action => "new" }
        format.xml  { render :xml => @colony.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /colonies/1
  # PUT /colonies/1.xml
  def update
    @colony = Colony.find(params[:id])

    respond_to do |format|
      if @colony.update_attributes(params[:colony])
        format.html { redirect_to(@colony, :notice => 'Colony was successfully updated.') }
        format.xml  { head :ok }
      else
        @celestial_bodies = CelestialBody.habitable.unoccupied
        @users = User.active
        format.html { render :action => "edit" }
        format.xml  { render :xml => @colony.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /colonies/1
  # DELETE /colonies/1.xml
  def destroy
    @colony = Colony.find(params[:id])
    @colony.destroy

    respond_to do |format|
      format.html { redirect_to(colonies_url) }
      format.xml  { head :ok }
    end
  end
end
