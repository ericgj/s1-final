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
    
    # 1. Restrict the rows to dates that occur in June 2006
    
    reduced_rows_table = \
      input_table.select do |rows|
        rows.where {|row| row['PROCEDURE_DATE'].value =~ /06\/\d\d\/06/ }
      end

      
    # 2. Convert the AMOUNT, TARGET_AMOUNT, and AMTPINSPAID columns 
    #    to money format. (e.g 1500 becomes $15.00)
    
    %w{AMOUNT TARGET_AMOUNT AMTPINSPAID}.each do |cname|
      reduced_rows_table.col(cname).each do |cell| 
        dec = cell.value[-2,2].to_i
        units = cell.value[0, (cell.value.size - 2)].to_i
        cell.value = "$#{units}.#{(dec.to_s.size == 1 ? '0' : '') + dec.to_s}"
      end
    end

    
    # 3. Remove the Count column
    
    reduced_rows_table.delete_col_data!('Count')
    
    
    # 4. Change the date format to YYYY-MM-DD
    reduced_rows_table.col('PROCEDURE_DATE').each do |cell|
      cell.value.gsub!(
          /(\d\d)\/(\d\d)\/(\d\d)/,
          '20\3-\1-\2'
        )
    end
    
    # 5. Convert the table to an array of arrays, 
    #    and then write out a YAML file
    
    reduced_rows_table.dump(
      OUTPUT_FILE, :yaml, :headers => true
    )
    
    
  end
  
end
