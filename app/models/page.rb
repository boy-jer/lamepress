class Page < ActiveRecord::Base

	after_save :cache_expiration
  after_destroy :cache_expiration

  attr_accessor :preview

	include ActionView::Helpers::TextHelper # for using 'truncate' method on prettify_permalink
  before_validation :prettify_permalink

  validates :name, :length => { :maximum => 250 }
  validates :permalink, :presence => true
  validates :permalink, :uniqueness => true
  validates :permalink, :length => { :maximum => 250 }
  validates :title, :length => { :maximum => 250 }
  validates :title, :presence => true
  validates :meta_description, :length => { :maximum => 250 }
  validates :permalink, :length => { :maximum => 250 }

  scope :published_only, where(published: true)



  def prettify_permalink
    # parameterize function is nice but not as good as below
    self.permalink = truncate(self.permalink.strip.gsub(/[\~]|[\`]|[\!]|[\@]|[\#]|[\$]|[\%]|[\^]|[\&]|[\*]|[\(]|[\)]|[\+]|[\=]|[\{]|[\[]|[\}]|[\]]|[\|]|[\\]|[\:]|[\;]|[\"]|[\']|[\<]|[\,]|[\>]|[\.]|[\?]|[\/]/,"").gsub(/\s+/,"-").downcase, length: 50, separator: "-", omission: "")
  end


  private
  def cache_expiration
  end
end