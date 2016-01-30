class SquadronsController < ApplicationController
  require_role 'zeus'
  
  # GET /squadrons
  # GET /squadrons.xml
  def index
    @squadrons = Squadron.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @squadrons }
    end
  end

  # GET /squadrons/1
  # GET /squadrons/1.xml
  def show
    @squadron = Squadron.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @squadron }
    end
  end

  # GET /squadrons/new
  # GET /squadrons/new.xml
  def new
    @squadron = Squadron.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @squadron }
    end
  end

  # GET /squadrons/1/edit
  def edit
    @squadron = Squadron.find(params[:id])
  end

  # POST /squadrons
  # POST /squadrons.xml
  def create
    @squadron = Squadron.new(params[:squadron])

    respond_to do |format|
      if @squadron.save
        format.html { redirect_to(@squadron, :notice => 'Squadron was successfully created.') }
        format.xml  { render :xml => @squadron, :status => :created, :location => @squadron }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @squadron.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /squadrons/1
  # PUT /squadrons/1.xml
  def update
    @squadron = Squadron.find(params[:id])

    respond_to do |format|
      if @squadron.update_attributes(params[:squadron])
        format.html { redirect_to(@squadron, :notice => 'Squadron was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @squadron.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /squadrons/1
  # DELETE /squadrons/1.xml
  def destroy
    @squadron = Squadron.find(params[:id])
    @squadron.destroy

    respond_to do |format|
      format.html { redirect_to(squadrons_url) }
      format.xml  { head :ok }
    end
  end
end
