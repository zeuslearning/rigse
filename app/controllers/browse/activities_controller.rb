class Browse::ActivitiesController < ApplicationController
  
  # GET /browse/activity/1
  def show
    @back_url = nil
    if request.post?
      @back_url = url_for :controller => '/search', :action => 'index',:search_term=>params["search_term"],:activity_page=>params["activity_page"],:investigation_page=>params["investigation_page"],:type=>"act"
    end
    
    @material = ::Activity.find(params[:id])
    if @material.teacher_only && current_user.anonymous?
      flash.now[:notice] = 'Please log in as a teacher to see this content.'
    end
    @wide_content_layout = true
    if @material.parent
      activity_title ="#{@material.name} | #{@material.parent.name}"
    else
      activity_title=@material.name
    end
    @page_title = activity_title
    @meta_title = @page_title
    
    @og_title = @page_title
    @og_type = 'website'
    @og_url = request.url
    @og_image_url = url_for('/assets/search/activity.gif')
    
    if @material.description.blank?
      @meta_description = "Check out this great activity from the Concord Consortium."
    else
      @meta_description = @material.description
    end
    
    @og_description = @meta_description
    
  end

end
