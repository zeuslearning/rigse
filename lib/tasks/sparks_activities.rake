namespace :app do
  namespace :import do
    
    require 'fileutils'

    def sparks_content_dir
      @sparks_content_dir || @sparks_content_dir = File.join(::Rails.root.to_s, 'public', 'sparks-content')
    end
    
    def git_svn_update_sparks_content
      Dir.chdir(sparks_content_dir) do
        puts "\nupdating local git repository of sparks-content: #{sparks_content_dir}"
        `git svn rebase`
      end
    end

    def git_update_sparks_content
      Dir.chdir(sparks_content_dir) do
        puts "\nupdating local git repository of sparks-content: #{sparks_content_dir}"
        `git pull`
      end
    end
  
    def git_clone_sparks_content
      puts "\ncreating local git repository of sparks-content: #{sparks_content_dir}"
      `git clone git://github.com/gigamorph/sparks.git public/sparks-content`
    end
    
    def git_svn_clone_sparks_content
      puts "\ncreating local git repository of sparks-activities: #{sparks_content_dir}"
      `git svn clone https://svn.concord.org/svn/projects/trunk/sparks/sparks-content public`
    end


    desc "create or update a git svn clone of sparks-activities"
    task :create_or_update_sparks_content => :environment do
      if File.exists? File.join(sparks_content_dir, '.git')
        git_update_sparks_content
      else
        git_clone_sparks_content
      end
    end
  end
end


