class DepositsController < ApplicationController
  require_role 'zeus'
  
  # GET /deposits/new
  # GET /deposits/new.xml
  def new
    @deposit = Deposit.new
    @deposit.celestial_body = CelestialBody.find(params[:celestial_body_id]) unless params[:celestial_body_id].nil?
    @items = Item.commodities
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @deposit }
    end
  end

  # GET /deposits/1/edit
  def edit
    @deposit = Deposit.find(params[:id])
    @items = Item.commodities
  end

  # POST /deposits
  # POST /deposits.xml
  def create
    @deposit = Deposit.new(params[:deposit])

    respond_to do |format|
      if @deposit.save
        format.html { redirect_to(@deposit.celestial_body, :notice => 'Deposit was successfully created.') }
        format.xml  { render :xml => @deposit, :status => :created, :location => @deposit }
      else
        @items = Item.commodities
        format.html { render :action => "new" }
        format.xml  { render :xml => @deposit.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /deposits/1
  # PUT /deposits/1.xml
  def update
    @deposit = Deposit.find(params[:id])

    respond_to do |format|
      if @deposit.update_attributes(params[:deposit])
        format.html { redirect_to(@deposit.celestial_body, :notice => 'Deposit was successfully updated.') }
        format.xml  { head :ok }
      else
        @items = Item.commodities
        format.html { render :action => "edit" }
        format.xml  { render :xml => @deposit.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /deposits/1
  # DELETE /deposits/1.xml
  def destroy
    @deposit = Deposit.find(params[:id])
    @celestial_body = @deposit.celestial_body
    @deposit.destroy

    respond_to do |format|
      format.html { redirect_to(@celestial_body) }
      format.xml  { head :ok }
    end
  end
end
