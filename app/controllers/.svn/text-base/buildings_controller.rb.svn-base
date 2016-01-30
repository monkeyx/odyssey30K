class BuildingsController < ApplicationController
  require_role 'zeus'
  
  # GET /buildings/1
  # GET /buildings/1.xml
  def show
    @building = Building.find(params[:id])
    self.current_building = @building
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @building }
    end
  end

  # GET /buildings/new
  # GET /buildings/new.xml
  def new
    @building = Building.new
    @building.colony = Colony.find(params[:colony_id])
    @colonies = Colony.find(:all)
    @building_types = Item.buildings
    @users = User.find(:all)
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @building }
    end
  end

  # GET /buildings/1/edit
  def edit
    @building = Building.find(params[:id])
    @colonies = Colony.find(:all)
    @users = User.find(:all)
    @building_types = Item.buildings
  end

  # POST /buildings
  # POST /buildings.xml
  def create
    @building = Building.new(params[:building])

    respond_to do |format|
      if @building.save
        format.html { redirect_to(@building, :notice => 'Building was successfully created.') }
        format.xml  { render :xml => @building, :status => :created, :location => @building }
      else
        @colonies = Colony.find(:all)
        @users = User.find(:all)
        @building_types = Item.buildings
        format.html { render :action => "new" }
        format.xml  { render :xml => @building.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /buildings/1
  # PUT /buildings/1.xml
  def update
    @building = Building.find(params[:id])

    respond_to do |format|
      if @building.update_attributes(params[:building])
        format.html { redirect_to(@building, :notice => 'Building was successfully updated.') }
        format.xml  { head :ok }
      else
        @colonies = Colony.find(:all)
        @users = User.find(:all)
        @building_types = Item.buildings
        format.html { render :action => "edit" }
        format.xml  { render :xml => @building.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /buildings/1
  # DELETE /buildings/1.xml
  def destroy
    @building = Building.find(params[:id])
    @building.destroy

    respond_to do |format|
      format.html { redirect_to(buildings_url) }
      format.xml  { head :ok }
    end
  end
end
