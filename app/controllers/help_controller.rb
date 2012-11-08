class HelpController < ApplicationController
  caches_page   :project_css
  theme "rites"
  
  def index
    case current_project.help_type
    when 'no help'
      render :template => "help/no_help_page"
    when 'external url'
      external_url = current_project.external_url
      redirect_to "#{external_url}"
    when 'help custom html'
      @help_page_content = current_project.custom_help_page_html
    end
  end
  
  def preview_help_page
    if (params[:preview_help_page_from_edit])
      response.headers["X-XSS-Protection"] = "0"
      @help_page_preview_content = params[:preview_help_page_from_edit]
      return
    end

    @preview_help_project_id = params[:preview_help_page_from_summary_page] || @preview_help_project_id
    @preview_help_project_id = @preview_help_project_id.to_i
    preview_project = Admin::Project.find_by_id(@preview_help_project_id)
    case preview_project.help_type
    when 'no help'
      render :template => "help/no_help_page"
    when 'external url'
      external_url = preview_project.external_url
      redirect_to "#{external_url}"
    when 'help custom html'
      @help_page_preview_content = preview_project.custom_help_page_html
    end
  end
end
