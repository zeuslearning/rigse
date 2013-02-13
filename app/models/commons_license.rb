class CommonsLicense < ActiveRecord::Base
  set_primary_key  :code
  before_save :default_paths
  attr_accessible :name, :code, :deed, :legal, :image, :description

  Site = "creativecommons.org"

  ImageFormat = "http://i.#{Site}/l/%{code}/3.0/88x31.png"
  DeedFormat  =   "http://#{Site}/licenses/%{code}/3.0/"
  LegalFormat =   "http://#{Site}/licenses/%{code}/3.0/legalcode"

  default_scope :order => 'number ASC'

  def default_paths
    self.deed  ||= CommonsLicense.deed(self)
    self.legal ||= CommonsLicense.legal(self)
    self.image ||= CommonsLicense.image(self)
  end

  def self.for_select
    self.all.map { |l| [l.name,l.code] }
  end

  def self.url(license,fmt)
    modified_code = license.code.downcase
    modified_code.gsub!("cc-","")
    fmt % {:code => modified_code}
  end

  def self.image(license)
    url(license, ImageFormat)
  end

  def self.deed(license)
    url(license, DeedFormat)
  end

  def self.legal(license)
    url(license, LegalFormat)
  end

  def self.load_licenses
    defs = YAML::load_file(File.join(Rails.root,"config","licenses.yml"));
    defs['licenses'].each do |license|
      CommonsLicense.find_or_create_by_code(license)
    end
  end
  self.load_licenses
end
