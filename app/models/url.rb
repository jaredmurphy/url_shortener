class Url < ApplicationRecord
  before_validation :default_access_count
  after_create :generate_short_link

  validates :full_link,
    presence: true,
    format: URI::regexp(%w(http https)),
    uniqueness: true

  validates :access_count, presence: true
  validates :short_link, uniqueness: true

  def increment_access_count
    self.update_attributes!(access_count: access_count + 1)
  end

  scope :location, -> (s_link) { find_by(short_link: s_link).full_link }
  scope :top, -> { all.order(access_count: :desc) }

  def generate_short_link
    # concepts for generating short link are gathered from these two resources
    # http://stackoverflow.com/questions/742013/how-to-code-a-url-shortener/742047#742047
    # https://gist.github.com/zumbojo/1073996
    chars = [*'0'..'9', *'a'..'z', *'A'..'Z', "_", "-"]
    id = self.id
    short_link = bijective_encode(id, chars)
    self.update_attributes!(short_link: short_link)
  end

  private

  def default_access_count
    self.access_count = 0 if self.access_count.nil?
  end

  def get_chars_hash
    chars = [*'0'..'9', *'a'..'z', *'A'..'Z', "_", "-"]
  end

  def bijective_encode(id, chars)
    return chars[0] if id == 0
    string = ""
    base = chars.length
    while id > 0
      string << chars[id.modulo(base)]
      id /= base
    end
    string.reverse
  end
end
