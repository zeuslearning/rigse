
D:\GIT\RIGSE>@git.exe %*
class Admin::NoticeUserDisplayStatus < ActiveRecord::Base
  self.table_name = "admin_notice_user_display_statuses"
  belongs_to :user, :class_name => "User", :foreign_key => "user_id"
  validates :user_id, :last_collapsed_at_time, :presence => true
end

D:\GIT\RIGSE>@set ErrorLevel=%ErrorLevel%

D:\GIT\RIGSE>@rem Restore the original console codepage.

D:\GIT\RIGSE>@chcp %cp_oem% > nul < nul
