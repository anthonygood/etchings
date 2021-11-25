class Etching < ActiveRecord::Base

  validates :title, presence: true, string: true
  validates_with StringValidator, attributes: [:long_description, :short_description, :notes], allow_blank: true
  validates_numericality_of :height, :width, :plates, :print_run, { only_integer: true, allow_blank: true }
  validates :year, { year: true, allow_blank: true }

  has_many :prints, dependent: :destroy
  has_many :inquiries
  has_and_belongs_to_many :themes

  scope :landscape, -> { where('width > height') }
  scope :portrait,  -> { where('height > width') }
  scope :listed,    -> { where(listed: true)     }
  scope :unlisted,  -> { where(listed: false)    }

  class << self
    def create_with_prints(attributes={})
      raise ArgumentError, "You must specify which prints to create" unless attributes[:versions]
      etching = create! attributes.except(:versions)

      attributes[:versions].each do |version|
        Print.create_with_image(etching, "jpg", version)
      end

      etching
    end

    def create_with_prints_and_themes(attributes={})
      raise ArgumentError, "You must specify which themes to create" unless attributes[:themes]
      etching = create_with_prints attributes.except(:themes)

      attributes[:themes].each do |theme|
        etching.themes << Theme.where(name: theme).first_or_create
        etching.save
      end

      etching
    end

    def previous(etching)
      where(["id < ?", etching.id]).last
    end

    def next(etching)
      where(["id > ?", etching.id]).first
    end
  end

  def orientation
    return nil unless @width && @height
    if @width > @height
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
