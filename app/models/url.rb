class Url < ApplicationRecord
  before_validation :default_access_count
  after_create :generate_short_link

  validates :full_link,
    presence: true,
    format: URI::regexp(%w(http https)),
    uniqueness: true

  validates :access_count, presence: true
  validates :short_link, uniqueness: true

  @@chars = [*'0'..'9', *'a'..'z', *'A'..'Z', "_", "-"]

  scope :location, -> (s_link) { Url.find(generate_id_from_short_link(s_link)) }
  scope :top, -> { all.order(access_count: :desc) }

  def increment_access_count
    self.update_attributes!(access_count: access_count + 1)
  end

  def generate_short_link
    # concepts for generating short link are gathered from these two resources
    # http://stackoverflow.com/questions/742013/how-to-code-a-url-shortener/742047#742047
    # https://gist.github.com/zumbojo/1073996
    id = self.id
    short_link = bijective_encode(id)
    self.update_attributes!(short_link: "#{ENV['ENV_URL']}#{short_link}")
  end

  def self.generate_id_from_short_link(short_link)
    bijective_decode(short_link)
  end

  private

  def default_access_count
    self.access_count = 0 if self.access_count.nil?
  end

  def bijective_encode(id)
    return @@chars[0] if id == 0
    string = ""
    base = @@chars.length
    while id > 0
      string << @@chars[id.modulo(base)]
      id /= base
    end
    string.reverse
  end

  def self.bijective_decode(string)
    id = 0
    base = @@chars.length
    string.each_char { |c| id = id * base + @@chars.index(c) }
    id
  end
end
