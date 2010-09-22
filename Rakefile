task :default => ['test:all']

namespace :test do
    
  task :unit do
    puts "-----------------------\nUnit tests\n-----------------------"
    Dir['test/unit/**/*.rb'].each do |f| 
      puts "#{File.basename(f, '.rb')}"
      load f
    end
  end

  task :all do
    Rake::Task['test:unit'].execute    
  end
  
end
