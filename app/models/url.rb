class Url < ApplicationRecord
  before_validation :generate_short_link, :default_access_count 

  validates :full_link, 
    presence: true, 
    format: URI::regexp(%w(http https)),
    uniqueness: true

  validates :access_count, presence: true
  validates :short_link, presence: true, uniqueness: true

  def increment_access_count 
    self.access_count = self.access_count + 1 
  end

  private 

  def default_access_count
    self.access_count = 0 if self.access_count.nil?
  end

  def generate_short_link
    self.short_link = loop do 
      random_string = SecureRandom.urlsafe_base64(5) 
      break random_string unless Url.exists?(short_link: random_string)
    end
  end
end
