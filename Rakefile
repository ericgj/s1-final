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

## Task for running scenario
## Note does not yet work

namespace :scenario do
  
  task :setup do
    require 'lib/data_table'
  end
  
  task :run => [:setup] do
  
    SAMPLE_FILE = 'scenario/sample_data/s1-exam-data.yaml'
    OUTPUT_FILE = 'scenario/s1-exam-data-transformed.yaml'
    
    input_table = RMU::Data::Table.load(
                    SAMPLE_FILE, :yaml, :headers => true
                  )
    
    reduced_rows_table = \
      input_table.select do |rows|
        rows.where {|row| row['PROCEDURE_DATE'] =~ /06\/\d\d\/10/ }
      end

    reduced_rows_table.delete_col('Count')
    
    reduced_rows_table.col('PROCEDURE_DATE').each do |cell|
      cell.value = \
        cell.value.gsub(
          /(\d\d)\/(\d\d)\/(\d\d)/,
          "20#{$3}-#{$1}-#{$2}"
        )  # whatever the syntax is, this isn't quite right
    end
    
    reduced_rows_table.dump(
      OUTPUT_FILE, :yaml, :headers => true
    )
    
  end
  
end
