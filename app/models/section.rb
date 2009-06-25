class Section < ActiveRecord::Base
  belongs_to :activity
  belongs_to :user
  has_many :pages, :order => :position, :dependent => :destroy

  has_many :data_collectors,
     :finder_sql => 'SELECT data_collectors.* FROM data_collectors
     INNER JOIN page_elements ON data_collectors.id = page_elements.embeddable_id AND page_elements.embeddable_type = "DataCollector"
     INNER JOIN pages ON page_elements.page_id = pages.id
     WHERE pages.section_id = #{id}'
  
  acts_as_list :scope => :activity_id
  accepts_nested_attributes_for :pages, :allow_destroy => true 

  acts_as_replicatable

  include Changeable
  
  has_many :teacher_notes, :as => :authored_entity
  has_many :author_notes, :as => :authored_entity
  include Noteable # convinience methods for notes...
  
  validates_presence_of :name, :on => :create, :message => "can't be blank"
  
  default_value_for :name, "name of section"
  default_value_for :description, "describe the purpose of this section here..."
  
  def self.display_name
    'Section'
  end

  def parent
    return activity
  end
  
  def next(page)
    index = pages.index(page)
    if index
      return pages[index+1]
    end
    return nil
  end
  
  def previous(page)
    index = pages.index(page)
    if index && (index > 0)
      return pages[index-1]
    end
    return nil
  end
  
  def deep_set_user user
    self.user = user
    self.pages.each do |p|
      p.deep_set_user(user)
    end
  end
  
  ## in_place_edit_for calls update_attribute.
  def update_attribute(name, value)
    update_investigation_timestamp if super(name, value)
  end

  ## Update timestamp of investigation that the activity belongs to 
  def update_investigation_timestamp
    activity = self.activity
    activity.update_investigation_timestamp if activity
  end
  
end



#  Recent schema definition:
# create_table "sections", :force => true do |t|
#   t.datetime "created_at"
#   t.datetime "updated_at"
#   t.string   "name"
#   t.string   "description"
#   t.integer  "user_id"
#   t.integer  "position"
#   t.integer  "activity_id"
#   t.string   "uuid",             :limit => 36
# end
