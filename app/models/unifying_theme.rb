class UnifyingTheme < ActiveRecord::Base
  belongs_to :user
  has_many :big_ideas
  has_many :assessment_targets
  has_many :knowledge_statements, :through => :assessment_targets
  has_many :grade_span_expectations, :through => :assessment_targets
  
  acts_as_replicatable
  
  include Changeable
  
end
