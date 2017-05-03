class Url < ApplicationRecord
  before_save :default_access_count

  validates :full_link, presence: true, format: URI::regexp(%w(http https))
  validates :access_count, presence: true
  #validates :short_url, presence: true

  def default_access_count
    self.access_count = 0 if self.access_count.nil?
  end

  def increment_access_count 
    self.access_count = self.access_count + 1 
  end

end
