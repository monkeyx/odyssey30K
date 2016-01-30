class KnowledgesController < ApplicationController
  require_role 'zeus', :for_all_except => [:index, :show]
  require_role 'senator', :for => [:index, :show]
  
  # GET /knowledges
  # GET /knowledges.xml
  def index
    filter = params[:filter] || 'all'
    filter = 'all' unless Knowledge::ALLOWED_FILTERS.include?(filter)
    
    @knowledges = Knowledge.send(filter.to_sym)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @knowledges }
    end
  end

  # GET /knowledges/1
  # GET /knowledges/1.xml
  def show
    @knowledge = Knowledge.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @knowledge }
    end
  end

  # GET /knowledges/new
  # GET /knowledges/new.xml
  def new
    @knowledge = Knowledge.new
    @knowledges = Knowledge.find(:all)
    @items = Item.find(:all)
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @knowledge }
    end
  end

  # GET /knowledges/1/edit
  def edit
    @knowledge = Knowledge.find(params[:id])
    @knowledges = Knowledge.find(:all, :conditions => ['id <> ?', params[:id]])
    @items = Item.find(:all)
  end

  # POST /knowledges
  # POST /knowledges.xml
  def create
    @knowledge = Knowledge.new(params[:knowledge])

    respond_to do |format|
      if @knowledge.save
        format.html { redirect_to(@knowledge, :notice => 'Knowledge was successfully created.') }
        format.xml  { render :xml => @knowledge, :status => :created, :location => @knowledge }
      else
        @knowledges = Knowledge.find(:all)
        @items = Item.find(:all)
        format.html { render :action => "new" }
        format.xml  { render :xml => @knowledge.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /knowledges/1
  # PUT /knowledges/1.xml
  def update
    @knowledge = Knowledge.find(params[:id])

    respond_to do |format|
      if @knowledge.update_attributes(params[:knowledge])
        format.html { redirect_to(@knowledge, :notice => 'Knowledge was successfully updated.') }
        format.xml  { head :ok }
      else
        @knowledges = Knowledge.find(:all, :conditions => ['id <> ?', params[:id]])
        @items = Item.find(:all)
        format.html { render :action => "edit" }
        format.xml  { render :xml => @knowledge.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /knowledges/1
  # DELETE /knowledges/1.xml
  def destroy
    @knowledge = Knowledge.find(params[:id])
    @knowledge.destroy

    respond_to do |format|
      format.html { redirect_to(knowledges_url) }
      format.xml  { head :ok }
    end
  end
end
