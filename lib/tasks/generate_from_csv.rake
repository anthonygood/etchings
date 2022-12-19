# Work in Progress

require 'string_colours'
require 'csv'
require_relative '../csv_translator'

# rake generate_from_csv['file/path']
task :generate_from_csv, [:csv_path] => :environment do |t, args|
  file = args[:csv_path]
  raise "Please provide a path to a valid CSV file" unless file
  puts "Supplied load path: #{args[:csv_path]}"

  translator = CSVTranslator.new file, Etching
  translator.write_records_to_db

  if translator.errors?
    puts "There were errors writing the following records to the database:"
    puts translator.translations_with_errors
  else
    puts "There were no errors to report."
  end
end
