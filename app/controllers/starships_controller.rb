class StarshipsController < ApplicationController
  require_role 'zeus', :for_all_except => [:index, :show, :change_name, :buy, :take_off, :dock, :thrust_move, :scan, :probe, :buy, :sell, :scrap_section, :install_section, :hire_crew, :sack_crew]
  require_role 'freeman', :for => [:index, :show, :change_name, :take_off, :dock, :thrust_move, :scan, :probe, :buy, :sell, :scrap_section, :install_section, :hire_crew, :sack_crew]
  require_role 'zeus', :for => [:show, :change_name, :take_off, :dock, :thrust_move, :scan, :probe, :buy, :sell, :scrap_section, :install_section, :hire_crew, :sack_crew], :unless => "current_user.authorized_for_starship?(params[:id])"

  skip_before_filter :verify_authenticity_token 
  
  def sack_crew
    @starship = Starship.find(params[:id])
    respond_to do |format| 
      if @starship.colony
        @market_order = MarketOrder.new
        @market_order.colony = @starship.colony
        @market_order.destination = @starship
        @market_order.ship_crew = true
        # show sell form
        format.html {render :layout => 'colorbox'}
      else
        format.html {render :text => "Invalid location"}
        format.json {render :json => "Invalid location"}
      end
    end
  end

  def hire_crew
    @starship = Starship.find(params[:id])
    respond_to do |format| 
      if @starship.colony
        @market_order = MarketOrder.new
        @market_order.colony = @starship.colony
        @market_order.destination = @starship
        @market_order.ship_crew = true
        @market_orders = MarketOrder.at_colony(@starship.colony).in_items(Item.crew).buying_or_selling('sell').all(:order => 'price ASC')
        # show buy form
        format.html {render :layout => 'colorbox'}
      else
        format.html {render :text => "Invalid location"}
        format.json {render :json => "Invalid location"}
      end
    end
  end
  
  def install_section
    @starship = Starship.find(params[:id])
    respond_to do |format| 
      if @starship.colony
        @market_order = MarketOrder.new
        @market_order.colony = @starship.colony
        @market_order.destination = @starship
        @market_order.install_section = true
        @market_orders = MarketOrder.at_colony(@starship.colony).in_items(Item.ship_sections).buying_or_selling('sell').all(:order => 'price ASC')
        # show form
        format.html {render :layout => 'colorbox'}
      else
        format.html {render :text => "Invalid location"}
        format.json {render :json => "Invalid location"}
      end
    end
  end
  
  def scrap_section
    @starship = Starship.find(params[:id])
    respond_to do |format| 
      if @starship.colony && @starship.colony.can_refit_starship? 
        unless params[:section].blank?
          @section = Item.find(params[:section])
          if @section && @starship.has_section?(@section)
            @starship.remove_section! @section
            format.json {render :json => {:success => true, :notice => "#{@section} removed from #{@starship.name}."}}
          else
            format.json {render :json => {:success => false, :notice => "Invalid section."}}
          end
        else
          # show form
          format.html {render :layout => 'colorbox'}
        end
      else
        format.json {render :json => {:success => false, :notice => "Invalid location."}}
      end
    end
  end
  
  def sell
    @starship = Starship.find(params[:id])
    respond_to do |format| 
      if @starship.colony
        @market_order = MarketOrder.new
        @market_order.colony = @starship.colony
        @market_order.destination = @starship
        # show sell form
        format.html {render :layout => 'colorbox'}
      else
        format.html {render :text => "Invalid location"}
        format.json {render :json => "Invalid location"}
      end
    end
  end

  def buy
    @starship = Starship.find(params[:id])
    respond_to do |format| 
      if @starship.colony
        @market_order = MarketOrder.new
        @market_order.colony = @starship.colony
        @market_order.destination = @starship
        @market_orders = MarketOrder.at_colony(@starship.colony).buying_or_selling('sell').all(:order => 'price ASC')
        # show buy form
        format.html {render :layout => 'colorbox'}
      else
        format.html {render :text => "Invalid location"}
        format.json {render :json => "Invalid location"}
      end
    end
  end
  
  def probe
    @starship = Starship.find(params[:id])
    if @starship.colony.nil? && @starship.use_energy!(Starship::PROBE_ENERGY_COST)
      flash[:probe] = true
      flash[:notice] = "#{@starship} probed #{@starship.location}"
      @starship.log!("Probed #{@starship.location}")
    elsif @starship.current_energy < Starship::PROBE_ENERGY_COST 
      flash[:warning] = "Insufficient energy"
    else
      flash[:error] = "Must be in orbit"
    end
    respond_to do |format|
      format.html {redirect_to @starship }
      format.json { render :json => @starship.location }
    end
  rescue Exception => e
    flash[:error] = e
    respond_to do |format|
      format.html {redirect_to @starship }
      format.json { render :json => e }
    end
  end
  
  def scan
    @starship = Starship.find(params[:id])
    if @starship.use_energy!(Starship::ACTIVE_SCAN_ENERGY_COST)
      flash[:scan] = true
      flash[:notice] = "#{@starship} performed a scan of the orbit of #{@starship.location}"
      @starship.log!("Scanned the orbit of #{@starship.location}")
    else
      flash[:warning] = "Insufficient energy"
    end
    respond_to do |format|
      format.html {redirect_to @starship }
      format.json { render :json => @starship.location }
    end
  rescue Exception => e
    flash[:error] = e
    respond_to do |format|
      format.html {redirect_to @starship }
      format.json { render :json => e }
    end
  end
  
  def thrust_move
    @starship = Starship.find(params[:id])
    @destination = CelestialBody.find(params[:body])
    if @destination.nil?
      flash[:error] = "Unknown destination."
    elsif @starship.overcapacity?
      flash[:warning] = "Cargo overcapacity - cannot move."
    elsif @starship.thrust_move!(@destination)
      flash[:notice] = "#{@starship.name} moved to orbit of #{@destination}."
      flash[:scan] = true
    else
      flash[:warning] = "#{@starship.name} failed to move to #{@destination}."
    end
    respond_to do |format|
      format.html {redirect_to @starship }
      format.json { render :json => @starship.location }
    end
  rescue Exception => e
    flash[:error] = e
    respond_to do |format|
      format.html {redirect_to @starship }
      format.json { render :json => e }
    end
  end
  
  def dock
    @starship = Starship.find(params[:id])
    @colony = Colony.find(params[:colony]) unless params[:colony].blank?
    if @starship.overcapacity?
      flash[:warning] = "Cargo overcapacity - cannot move."
    elsif @colony && @colony != @starship.celestial_body.colony && @colony.planet.star_system == @starship.star_system
      Kernel.p "!!! HERE 1 #{@starship.location} !!!"
      if @starship.thrust_move!(@colony.planet)
        flash[:scan] = true
        @starship.reload
        if @starship.dock!
          flash[:notice] = "#{flash[:notice]} #{@starship.name} docked at #{@colony}."
        else
          flash[:warning] = "#{@starship.name} moved to orbit of #{@colony.planet} but failed to dock at #{@colony}."
        end
      else
        flash[:warning] = "#{@starship.name} failed to move to #{@colony.planet}."
      end
    elsif @starship.dock!
      flash[:notice] = "#{@starship.name} docked at #{@starship.colony}."
      flash[:scan] = true
    else
      flash[:warning] = "#{@starship.name} failed to dock at #{@starship.colony}."
    end
    respond_to do |format|
      format.html {redirect_to @starship }
      format.json { render :json => @starship.location }
    end
  rescue Exception => e
    flash[:error] = e
    respond_to do |format|
      format.html {redirect_to @starship }
      format.json { render :json => e }
    end
  end
  
  def take_off
    @starship = Starship.find(params[:id])
    if @starship.overcapacity?
      flash[:warning] = "Cargo overcapacity - cannot move."
    elsif @starship.take_off!
      flash[:notice] = "#{@starship.name} took off into orbit."
      flash[:scan] = true
    else
      flash[:warning] = "#{@starship.name} failed to take off."
    end
    respond_to do |format|
      format.html {redirect_to @starship }
      format.json { render :json => @starship.location }
    end
  rescue Exception => e
    flash[:error] = e
    respond_to do |format|
      format.html {redirect_to @starship }
      format.json { render :json => e }
    end
  end
  
  def change_name
    @starship = Starship.find(params[:id])
    @starship.update_attributes!(:name => params[:name]) if @starship && !params[:name].nil?
    
    respond_to do |format|
      format.json { render :json => @starship.name }
    end
  end
  
  # GET /starships
  # GET /starships.xml
  def index
    @starships = current_user.starships
    if @starships.size == 1
      return redirect_to(@starships.first)
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @starships }
    end
  end

  # GET /starships/1
  # GET /starships/1.xml
  def show
    @starship = Starship.find(params[:id])
    self.current_starship = @starship
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @starship }
    end
  end

  # GET /starships/new
  # GET /starships/new.xml
  def new
    @starship = Starship.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @starship }
    end
  end

  # GET /starships/1/edit
  def edit
    @starship = Starship.find(params[:id])
  end

  # POST /starships
  # POST /starships.xml
  def create
    @starship = Starship.new(params[:starship])

    respond_to do |format|
      if @starship.save
        format.html { redirect_to(@starship, :notice => 'Starship was successfully created.') }
        format.xml  { render :xml => @starship, :status => :created, :location => @starship }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @starship.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /starships/1
  # PUT /starships/1.xml
  def update
    @starship = Starship.find(params[:id])

    respond_to do |format|
      if @starship.update_attributes(params[:starship])
        format.html { redirect_to(@starship, :notice => 'Starship was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @starship.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /starships/1
  # DELETE /starships/1.xml
  def destroy
    @starship = Starship.find(params[:id])
    @starship.destroy

    respond_to do |format|
      format.html { redirect_to(starships_url) }
      format.xml  { head :ok }
    end
  end
end
