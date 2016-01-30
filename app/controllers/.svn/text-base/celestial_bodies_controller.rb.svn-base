class CelestialBodiesController < ApplicationController
  require_role 'zeus', :for_all_except => [:show]
  require_role 'freeman', :for => [:show]
  
  # GET /celestial_bodies/1
  # GET /celestial_bodies/1.xml
  def show
    @celestial_body = CelestialBody.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @celestial_body }
    end
  end

  # GET /celestial_bodies/new
  # GET /celestial_bodies/new.xml
  def new
    @celestial_body = CelestialBody.new
    @celestial_body.star_system = StarSystem.find(params[:star_system_id]) unless params[:star_system_id].nil?
    @star_systems = StarSystem.find(:all)
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @celestial_body }
    end
  end

  # GET /celestial_bodies/1/edit
  def edit
    @celestial_body = CelestialBody.find(params[:id])
    @star_systems = StarSystem.find(:all)
  end

  # POST /celestial_bodies
  # POST /celestial_bodies.xml
  def create
    @celestial_body = CelestialBody.new(params[:celestial_body])

    respond_to do |format|
      if @celestial_body.save
        format.html { redirect_to(@celestial_body, :notice => 'CelestialBody was successfully created.') }
        format.xml  { render :xml => @celestial_body, :status => :created, :location => @celestial_body }
      else
        @star_systems = StarSystem.find(:all)
        format.html { render :action => "new" }
        format.xml  { render :xml => @celestial_body.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /celestial_bodies/1
  # PUT /celestial_bodies/1.xml
  def update
    @celestial_body = CelestialBody.find(params[:id])

    respond_to do |format|
      if @celestial_body.update_attributes(params[:celestial_body])
        format.html { redirect_to(@celestial_body, :notice => 'CelestialBody was successfully updated.') }
        format.xml  { head :ok }
      else
        @star_systems = StarSystem.find(:all)
        format.html { render :action => "edit" }
        format.xml  { render :xml => @celestial_body.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /celestial_bodies/1
  # DELETE /celestial_bodies/1.xml
  def destroy
    @celestial_body = CelestialBody.find(params[:id])
    @celestial_body.destroy

    respond_to do |format|
      format.html { redirect_to(celestial_bodies_url) }
      format.xml  { head :ok }
    end
  end
end
