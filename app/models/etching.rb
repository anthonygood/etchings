require 'json'

class Etching #< ActiveRecord::Base
  @@json = JSON.parse File.read('./db/etchings.json')
  class << self
    def all
      @@json
    end

    def index(etching)
      @@json.find_index { |obj| obj['title'] == etching['title'] }
    end

    def previous(etching)
      etchings[index(etching) - 1]
    end

    def next(etching)
      etchings[index(etching) + 1]
    end
  end

  def initialize(obj)
    @obj = obj
  end

  # delegate?
  def prints
    @obj['prints']
  end

  def height
    @obj['height']
  end

  def width
    @obj['width']
  end

  def title
    @obj['title']
  end

  def themes
    @obj['themes']
  end

  def listed
    !@obj['unlisted']
  end

  def orientation
    return nil unless width && height
    if width > height
      "landscape"
    else
      "portrait"
    end
  end

  def css_name
    title.downcase.gsub(' ', '-')
  end

  def as_json(options)
    super(options).merge "orientation" => orientation
  end
end
