class Embeddable::Diy::EmbeddedModelsController < ApplicationController
  # GET /Embeddable/embedded_models
  # GET /Embeddable/embedded_models.xml
  def index
    @embedded_models = Embeddable::Diy::EmbeddedModel.search(params[:search], params[:page], nil)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @embedded_models }
    end
  end

  # GET /Embeddable/embedded_models/1
  # GET /Embeddable/embedded_models/1.xml
  def show
    @embedded_model = Embeddable::Diy::EmbeddedModel.find(params[:id])
    if request.xhr?
      render :partial => 'show', :locals => { :embedded_model => @embedded_model }
    else
      respond_to do |format|
        format.html # show.html.erb
        format.otml { render :layout => "layouts/embeddable/embedded_model" } # embedded_model.otml.haml
        format.jnlp { render :partial => 'shared/show', :locals => { :runnable => @embedded_model , :teacher_mode => false } }
        format.config { render :partial => 'shared/show', :locals => { :runnable => @embedded_model, :session_id => (params[:session] || request.env["rack.session.options"][:id]) , :teacher_mode => false } }
        format.dynamic_otml { render :partial => 'shared/show', :locals => {:runnable => @embedded_model, :teacher_mode => @teacher_mode} }
        format.xml  { render :xml => @embedded_model }
      end
    end
  end

  # GET /Embeddable/embedded_models/1/print
  def print
    @embedded_model = Embeddable::Diy::EmbeddedModel.find(params[:id])
    respond_to do |format|
      format.html { render :layout => "layouts/embeddable/print" }
      format.xml  { render :xml => @embedded_model }
    end
  end

  # GET /Embeddable/embedded_models/new
  # GET /Embeddable/embedded_models/new.xml
  def new
    @embedded_model = Embeddable::Diy::EmbeddedModel.new
    if request.xhr?
      render :partial => 'remote_form', :locals => { :embedded_model => @embedded_model }
    else
      respond_to do |format|
        format.html
        format.xml  { render :xml => @embedded_model }
      end
    end
  end

  # GET /Embeddable/embedded_models/1/edit
  def edit
    @embedded_model = Embeddable::Diy::EmbeddedModel.find(params[:id])
    if request.xhr?
      render :partial => 'remote_form', :locals => { :embedded_model => @embedded_model }
    else
      respond_to do |format|
        format.html 
        format.xml  { render :xml => @embedded_model }
      end
    end
  end

  # POST /Embeddable/embedded_models
  # POST /Embeddable/embedded_models.xml
  def create
    @embedded_model = Embeddable::Diy::EmbeddedModel.new(params[:embedded_model])
    cancel = params[:commit] == "Cancel"
    if request.xhr?
      if cancel 
        redirect_to :index
      elsif @embedded_model.save
        render :partial => 'new', :locals => { :embedded_model => @embedded_model }
      else
        render :xml => @embedded_model.errors, :status => :unprocessable_entity
      end
    else
      respond_to do |format|
        if @embedded_model.save
          flash[:notice] = 'Embeddable::Diy::EmbeddedModel.was successfully created.'
          format.html { redirect_to(@embedded_model) }
          format.xml  { render :xml => @embedded_model, :status => :created, :location => @embedded_model }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @embedded_model.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # PUT /Embeddable/embedded_models/1
  # PUT /Embeddable/embedded_models/1.xml
  def update
    cancel = params[:commit] == "Cancel"
    @embedded_model = Embeddable::Diy::EmbeddedModel.find(params[:id])
    @page_element = @embedded_model.page_elements.first ## right now this is probably ok. if we ever embed the same embedded_model into multiple pages, we'll have to change this.
    if request.xhr?
      if cancel || @embedded_model.update_attributes(params[:embeddable_diy_embedded_model])
        render(:update) {|page|
          page.replace(dom_id_for(@embedded_model, :details), :partial => 'show', :locals => { :embedded_model => @embedded_model } )
          page.replace(dom_id_for(@page_element, :template_view_title), :partial => 'pages/template_view_title', :locals => {:page_element => @page_element})
        }
      else
        render :xml => @embedded_model.errors, :status => :unprocessable_entity
      end
    else
      respond_to do |format|
        if @embedded_model.update_attributes(params[:embeddable_diy_embedded_model])
          flash[:notice] = 'Embeddable::Diy::EmbeddedModel.was successfully updated.'
          format.html { redirect_to(@embedded_model) }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @embedded_model.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /Embeddable/embedded_models/1
  # DELETE /Embeddable/embedded_models/1.xml
  def destroy
    @embedded_model = Embeddable::Diy::EmbeddedModel.find(params[:id])
    respond_to do |format|
      format.html { redirect_to(embedded_models_url) }
      format.xml  { head :ok }
      format.js
    end
    
    # TODO:  We should move this logic into the model!
    @embedded_model.page_elements.each do |pe|
      pe.destroy
    end
    @embedded_model.destroy    
  end
end
