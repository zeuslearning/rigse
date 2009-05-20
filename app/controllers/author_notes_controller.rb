class AuthorNotesController < ApplicationController
  
  before_filter :setup_object, :except => [:index]
  
  def setup_object
    if params[:id]
      if params[:id].length == 36
        @author_note = AuthorNote.find(:first, :conditions => ['uuid=?',params[:id]])
      else
        @author_note = AuthorNote.find(params[:id])
      end
    elsif params[:author_note]
      @author_note = AuthorNote.new(params[:activity])
    elsif params[:authored_entity_type] && params[:authored_entity_id]
      @author_note = AuthorNote.find_by_authored_entity_type_and_authored_entity_id(params[:authored_entity_type],params[:authored_entity_id])
      if (@author_note.nil?)
        @author_note = AuthorNote.new
        @author_note.authored_entity_type=params[:authored_entity_type]
        @author_note.authored_entity_id=params[:authored_entity_id]
        @author_note.user = current_user
      end
    else
      @author_note = AuthorNote.new
      @author_note.user = current_user
    end
  end
  
  
  # GET /author_notes
  # GET /author_notes.xml
  def index
    @author_notes = AuthorNote.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @author_notes }
    end
  end

  # GET /author_notes/1
  # GET /author_notes/1.xml
  def show
    @author_note = AuthorNote.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @author_note }
    end
  end

  def show_author_note
    if @author_note.user == current_user
      render :update do |page|
          page.replace_html  'note', :partial => 'author_notes/remote_form', :locals => { :author_note => @author_note}
          page.visual_effect :toggle_blind, 'note'
      end
    else
      render :update do |page|
        page.replace_html  'note', :partial => 'author_notes/show', :locals => { :author_note => @author_note}
        page.visual_effect :toggle_blind, 'note'
      end
    end
  end
  
  # GET /author_notes/new
  # GET /author_notes/new.xml
  def new
    @author_note = AuthorNote.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @author_note }
    end
  end

  # GET /author_notes/1/edit
  def edit
    @author_note = AuthorNote.find(params[:id])
    respond_to do |format|
      format.js   { render :update do |page| 
        page.visual_effect :highlite, 'note' 
        end 
      }
    end
  end

  # POST /author_notes
  # POST /author_notes.xml
  def create
    @author_note = AuthorNote.new(params[:author_note])    
    if @author_note.save
      flash[:notice] = 'AuthorNote was successfully created.'
      if (request.xhr?)
         render :text => "<div class='notice'>Author note saved</div>"
      else
        respond_to do |format|
          format.html { redirect_to(@author_note) }
          format.xml  { render :xml => @author_note, :status => :created, :location => @author_note }
        end
      end
    end
  end

  # PUT /author_notes/1
  # PUT /author_notes/1.xml
  def update
    @author_note = AuthorNote.find(params[:id])
    if @author_note.update_attributes(params[:author_note])
      if (request.xhr?)
         render :text => "<div class='notice'>Author note saved</div>"
      else
        respond_to do |format|
          flash[:notice] = 'AuthorNote was successfully created.'
          format.html { redirect_to(@author_note) }
          format.xml  { render :xml => @author_note, :status => :created, :location => @author_note }
        end
      end
    end
  end

  # DELETE /author_notes/1
  # DELETE /author_notes/1.xml
  def destroy
    @author_note = AuthorNote.find(params[:id])
    @author_note.destroy
    respond_to do |format|
      format.html { redirect_to(author_notes_url) }
      format.xml  { head :ok }
    end
  end
end
