require 'csv'

class CSVTranslator
  attr_accessor :csv, :etching_model, :column_titles

  def initialize(file, etching_model)
    @etching_model = etching_model
    @csv           = CSV.read(file)
    @column_titles = csv.shift
  end

  def translations
    @translations ||= csv.collect do |row|
      row.each_with_index.inject(Translation.new invalid_keys) do |hash,(value,index)|
        hash[column_titles[index].to_sym] = value
        hash
      end
    end
  end

  def write_records_to_db(options={})
    translations.each do |t|
      begin
        if options[:themes]
          puts "** create with prints and themes"
          e = etching_model.create_with_prints_and_themes t.filter_with_prints_and_themes
        else
          puts "** create with prints"
          e = etching_model.create_with_prints t.filter_with_prints
        end
        puts "Successfully created record #{e}"
      rescue Exception => error
        t.reject_with_error(error)
        puts "Error creating record: #{t}, #{error}"
      end
    end
  end

  def errors?
    !translations_with_errors.empty?
  end

  def translations_with_errors
    translations.select { |t| t.error }
  end

  def invalid_column_titles
    column_titles - keys
  end

  private

  def keys
    etching_model.new.attributes.keys
  end

  def invalid_keys
    invalid_column_titles.collect(&:to_sym)
  end

  class Translation < Hash
    attr_accessor :invalid_keys

    def initialize invalid_keys=nil
      @invalid_keys = invalid_keys
    end

    def filter
      select { |k, v| !invalid_keys.include? k }
    end

    def filter_with_prints
      filter.merge({versions: prints})
    end

    def filter_with_prints_and_themes
      filter_with_prints.merge({themes: themes})
    end

    def reject_with_error error
      self[:error] = error
    end

    def error
      self[:error]
    end

    def prints
      collect {|k, v| v if k.match(/version/i) && !v.blank? }.compact
    end

    def themes
      begin
        self[:themes].split(/, ?/)
      rescue NoMethodError => error
        nil
      end
    end
  end

end
