class MarketOrdersController < ApplicationController
  require_role 'zeus', :for_all_except => [:index, :show, :new, :create]
  require_role 'freeman', :for => [:index, :show, :new, :create]
  
  skip_before_filter :verify_authenticity_token 
  
  # GET /market_orders
  # GET /market_orders.xml
  def index
    @colony = !params[:colony].blank? ? Colony.find(params[:colony]) : nil
    @items = !params[:filter].blank? ? Item.send(params[:filter].to_sym) : Item.all
    params[:buy_or_sell] = params[:buy_or_sell].blank? ? 'both' : params[:buy_or_sell]
    @market_orders = @colony ? MarketOrder.at_colony(@colony).in_items(@items).buying_or_selling(params[:buy_or_sell]) : MarketOrder.in_items(@items).buying_or_selling(params[:buy_or_sell])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @market_orders }
    end
  end

  # GET /market_orders/1
  # GET /market_orders/1.xml
  def show
    @market_order = MarketOrder.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @market_order }
    end
  end

  # GET /market_orders/new
  # GET /market_orders/new.xml
  def new
    @market_order = MarketOrder.new(:buy_quantity => params[:buy_quantity], :sell_quantity => params[:sell_quantity], :price => params[:price])
    @starship = Starship.find(params[:starship]) unless params[:starship].blank?
    @building = Building.find(params[:building]) unless params[:building].blank?
    
    return access_denied if (@starship && !@starship.captain == current_user) || (@building && !@building.owner == current_user)
    
    @starship = current_starship unless @starship || @building
    @colony = Colony.find(params[:colony]) unless params[:colony].blank?
    @colony ||= @starship.colony unless @starship.nil?
    @colony ||= @building.colony unless @building.nil?
    
    destination = @starship || @building
    
    unless @colony && destination
      render :text => "Invalid location"
      return
    end 
    
    @item = Item.find(params[:item]) unless params[:item].blank?
    
    @market_order.user = current_user
    @market_order.colony = @colony if @colony
    @market_order.destination = destination
    @market_order.item = @item if @item
    
    render :partial => 'form'
  end

  # GET /market_orders/1/edit
  def edit
    @market_order = MarketOrder.find(params[:id])
  end

  # POST /market_orders
  # POST /market_orders.xml
  def create
    @market_order = MarketOrder.new(params[:market_order])
    @market_order.user = current_user
    @starship = @market_order.destination if @market_order.destination.is_a?(Starship)
    @building = @market_order.destination if @market_order.destination.is_a?(Building)
    @colony = @market_order.colony
    return access_denied if (@starship && !@starship.captain == current_user) || (@building && !@building.owner == current_user)
    
    destination = @starship || @building
    return access_denied unless @colony && destination
    
    respond_to do |format|
      if @market_order.valid? && @market_order.price > 0
        if @market_order.buy_quantity > 0
          if destination && @market_order.install_section && !@market_order.ship_crew && destination.can_add_sections(@market_order.item) < 1
            format.js { render :json => {:success => false, :error => "No space to install #{@market_order.item}"} }
          elsif destination && !@market_order.install_section && @market_order.ship_crew && destination.can_hire_crew(@market_order.item) < 1
            format.js { render :json => {:success => false, :error => "No crew space for #{@market_order.item}"} }
          elsif destination && !@market_order.install_section && !@market_order.ship_crew && destination.space_for_item(@market_order.item) < 1
            format.js { render :json => {:success => false, :error => "No space for #{@market_order.item}"} }
          else
            qty_bought = @market_order.market_buy!
            if qty_bought && qty_bought > 0
              notice = "You have bought #{qty_bought} of #{@market_order.item}."
              format.js { render :json => {:success => true, :notice => notice} }
            elsif @market_order.building_destination? && qty_bought < @market_order.quantity
              notice = "You have bought #{qty_bought} of #{@market_order.item}.\n You placed an order to buy the rest to be delivered to #{destination} as soon as they are available."
              format.js { render :json => {:success => true, :notice => notice} }
            else
              format.js { render :json => {:success => false, :error => "You could not buy any #{@market_order.item} at that price."} }
            end
          end
        elsif @market_order.sell_quantity > 0
          qty_sold = @market_order.market_sell!
          notice = "You have sold #{qty_sold} of #{@market_order.item} immediately." if qty_sold && qty_sold > 0
          if qty_sold && qty_sold < @market_order.sell_quantity
            notice = "You have sold #{qty_sold} of #{@market_order.item} immediately.\n You placed an order to sell the rest as soon as there is demand for it."
          end
          format.js { render :json => {:success => true, :notice => notice} }
        else
          format.js { render :json => {:success => false, :error => "Must buy or sell at least one item."} }
        end
      else
        if @market_order.errors.size > 0
          error = activerecord_error_list(@market_order.errors)
        else
          error = "Must offer a price greater than zero."
        end
        format.js { render :json => {:success => false, :error => error} }
      end
    end
  end

  # PUT /market_orders/1
  # PUT /market_orders/1.xml
  def update
    @market_order = MarketOrder.find(params[:id])

    respond_to do |format|
      if @market_order.update_attributes(params[:market_order])
        format.html { redirect_to(@market_order, :notice => 'MarketOrder was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @market_order.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /market_orders/1
  # DELETE /market_orders/1.xml
  def destroy
    @market_order = MarketOrder.find(params[:id])
    @market_order.destroy

    respond_to do |format|
      format.html { redirect_to(market_orders_url) }
      format.xml  { head :ok }
    end
  end
end
