
D:\GIT\RIGSE>@git.exe %*
class Admin::SiteNoticeUser < ActiveRecord::Base
  belongs_to :site_notice, :class_name => 'Admin::SiteNotice', :foreign_key => 'notice_id', :primary_key => 'id'
  belongs_to :user, :class_name => "User", :foreign_key => "user_id"
  
  validates :notice_id, :user_id, :presence => true
end

D:\GIT\RIGSE>@set ErrorLevel=%ErrorLevel%

D:\GIT\RIGSE>@rem Restore the original console codepage.

D:\GIT\RIGSE>@chcp %cp_oem% > nul < nul