class Report::Util
  ## FIXME Eventually this could use a service like memcached and then it wouldn't bloat the rails server processes
  
  ## 60 reports' details should be ok to hold in memory, for now
  MAX_CACHED_REPORTS = 60
  TRIM_BY = 10
  
  attr_accessor :offering, :learners
  attr_accessor :investigation, :activities, :sections, :pages, :page_elements
  # attr_accessor :saveables
  attr_accessor :saveables_by_embeddable
  # attr_accessor :saveables_by_type, :saveables_by_learner_id, :saveables_by_answered, :saveables_by_correct
  # attr_accessor :embeddables, :embeddables_by_type
  attr_accessor :last_accessed
  
  cattr_accessor :cache
  
  @@cache = {}
  
  def self.factory(offering)
    maintenance
    ## TODO This class should probably be thread-safe eventually
    @@cache[offering] ||= Report::Util.new(offering)
    return @@cache[offering]
  end
  
  def self.reload(offering)
    invalidate(offering)
    return factory(offering)
  end
  
  def self.invalidate(offering)
    @@cache.delete(offering)
  end
  
  def self.maintenance
    if @@cache.size > MAX_CACHED_REPORTS
      puts "Cache size is #{@@cache.size}. Trimming down."
      last_time = @@cache.values.sort_by{|v| v.last_accessed}[TRIM_BY].last_accessed
      @@cache.delete_if{|k,v| v.last_accessed < last_time }
      puts "Cache size is now #{@@cache.size}."
    end
  end
  
  def saveable(learner, embeddable)
    @last_accessed = Time.now
    results = Array(@saveables_by_embeddable[embeddable])
    results = results & Array(@saveables_by_learner_id[learner.id])
    results = [Saveable::SaveableStandin.new] if results.size < 1
    # there should be at most 1 saveable per learner, but you never know
    return results.first
  end
  
  def saveables(options = {})
    @last_accessed = Time.now
    results = @saveables
    results = Array(@saveables_by_learner_id[options[:learner].id]) if options[:learner]
    results = results & Array(@saveables_by_answered[true]) if options[:answered]
    results = results & Array(@saveables_by_embeddable[options[:embeddable]]) if options[:embeddable]
    results = results & Array(@saveables_by_correct[true]) if options[:correct]
    return results
  end
  
  def embeddables(options = {})
    @last_accessed = Time.now
    results = @embeddables
    results = Array(@embeddables_by_type[options[:type].to_s]) if options[:type.to_s]
    return results
  end
  
  def initialize(offering)
    @last_accessed = Time.now
    @offering = offering
    @learners = @offering.learners
    @investigation = offering.runnable
    
    @saveables = []
    @saveables_by_type = {}
    @saveables_by_learner_id = {}
    @saveables_by_embeddable = {}
    @saveables_by_correct = {}
    @saveables_by_answered = {}
    
    elements = PageElement.by_investigation(@offering.runnable).by_type(Investigation.reportable_types.map{|t| t.to_s}).to_a
    @embeddables = elements.map{|e| e.embeddable}.uniq
    @embeddables_by_type = @embeddables.group_by{|e| e.class.to_s }
    
    @activities = @investigation.activities
    @sections = @investigation.sections
    @pages = @investigation.pages
    
    activity_lambda = lambda {|e| @activities.detect{|a| a.id == e.activity_id.to_i} }
    section_lambda = lambda {|e| @sections.detect{|s| s.id == e.section_id.to_i} }
    page_lambda = lambda {|e| @pages.detect{|p| p.id == e.page_id.to_i} }
    @page_elements = elements.extended_group_by([activity_lambda, section_lambda, page_lambda])
    
    learner_lambda = lambda{|s| s.learner_id }
    embeddable_lambda = lambda{|s|
      result = nil
      result = s.open_response_id if s.respond_to? 'open_response_id'
      result = s.multiple_choice_id if s.respond_to? 'multiple_choice_id'
      result
    }
    
    Investigation.saveable_types.each do |type|
      all = type.find_all_by_offering_id(@offering.id)
      @saveables += all
      @saveables_by_type[type.to_s] = all
    end
    @saveables_by_answered = @saveables.group_by{|s| s.answered? }
    @saveables_by_correct = @saveables.group_by{|s| (s.respond_to? 'answered_correctly?') ? s.answered_correctly? : false}
    @saveables_by_learner_id = @saveables.group_by{|s| s.learner_id}
    @saveables_by_embeddable = @saveables.group_by{|s|
      type = Investigation.reportable_types.map{|t| {:klass => t, :str => t.to_s.demodulize.underscore} }.detect{|type| s.respond_to?(type[:str])}
      embeddable = @embeddables.detect{|e| e.class == type[:klass] && e.id == s.send("#{type[:str]}_id")}
    }
  end

end