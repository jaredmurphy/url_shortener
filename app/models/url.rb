class Url < ApplicationRecord
  before_validation :default_access_count
  before_save :generate_short_link

  validates :full_link,
    presence: true,
    format: URI::regexp(%w(http https)),
    uniqueness: true

  validates :access_count, presence: true
  validates :short_link, uniqueness: true

  def increment_access_count
    self.access_count = self.access_count + 1
  end

  scope :location, -> (s_link) { find_by(short_link: s_link).full_link }
  scope :top, -> { all.order(access_count: :desc) }

  private

  def default_access_count
    self.access_count = 0 if self.access_count.nil?
  end

  def get_chars_hash
    chars = [*'0'..'9', *'a'..'z', *'A'..'Z', "_", "-"]
    chars.each_with_index.reduce({}) do |hash, (string, i)|
      hash[i + 1] = string
      hash
    end
  end

   def generate_short_link
    chars = get_chars_hash
    if !Url.last # if this is the first entry
       self.short_link = chars[1]
    else
      last_entry = Url.last
      byebug if last_entry.short_link == ""
      last_entry_split = last_entry.short_link.split("")
      last_entry_keys = map_values_to_keys(last_entry_split, chars)

      perumutations_left(last_entry_split, last_entry_keys, chars)
    end
  end

  def perumutations_left(last_entry_split, last_entry_keys, chars)
    if last_entry_keys.uniq == [64]
      add_new_character(last_entry_keys, chars)
    elsif  last_entry_keys.last != 64
      increment_short_url(last_entry_keys, chars)
    elsif last_entry_keys.last == 64
      move_to_next_row(last_entry_split, last_entry_keys, chars)
    end
  end

  def add_new_character(last_entry_keys, chars) # adds a new character in the short_link string
    #byebug if last_entry_keys.last == 64
    new_keys = last_entry_keys.map {|num| chars.keys.first}
    new_keys.push(chars.keys.first)
    short_link = new_keys.map do |num|
      chars[num]
    end
    self.short_link = short_link.join("")
  end

  def increment_short_url(last_entry_keys, chars) # increment the last character
    #byebug if !last_entry_keys.last
    num = last_entry_keys.last
    last_entry_keys.pop
    last_entry_keys.push num + 1

    short_link = last_entry_keys.map {|num| chars[num]}

    self.short_link = short_link.join("")
  end

  def move_to_next_row(last_entry_split, last_entry_keys, chars)
  # replace the second to last character with the incremented key
    new_keys = last_entry_keys.each_with_index.map do |key, index|
      if key < 64 # if key < 64 and the next one = 64, then we need to increment this one
        if last_entry_keys[+1] == 64
          key = key + 1
        end
      elsif key == 64
        key = 1
      end
      key
    end

      short_link = new_keys.map do |num|
        chars[num]
      end
      self.short_link = short_link.join("")
  end

  def map_keys_to_values_and_set_short_link
  end


  # def generate_short_link
  #   chars = get_chars_hash
  #   if !Url.last # if this is the first entry
  #      self.short_link = chars[1]
  #   else
  #     last_entry = Url.last
  #     last_entry_split = last_entry.short_link.split("")
  #     last_entry_keys = map_values_to_keys(last_entry_split, chars)

  #     perumutations_left(last_entry_split, last_entry_keys, chars)
  #   end
  # end

  # def add_new_character(last_entry_keys, chars) # adds a new character in the short_link string
  #   last_entry_keys[-1] = chars.keys.first
  #   last_entry_keys.push chars.keys.first

  #   short_link = last_entry_keys.map do |num|
  #     chars[num]
  #   end
  #   puts "add new character #{short_link.join("")}"
  #   self.short_link = short_link.join("")
  # end

  # def perumutations_left(last_entry_split, last_entry_keys, chars)
  #   if last_entry_keys.last == 64

  #     if last_entry_split.length == 1 # if this is the first time we're adding a new character

  #       puts "ADD NEW CHARACTER"
  #       add_new_character(last_entry_keys, chars)
  #     else
  #       puts "MOVE TO NEXT ROW"
  #       move_to_next_row(last_entry_split, last_entry_keys, chars)
  #     end
  #   elsif # last key is anytyihng other than 64

  #     #puts "#{last_entry_split}, #{last_entry_keys}, #{chars}"
  #     increment_short_url(last_entry_keys, chars)
  #   end
  # end

  # def move_to_next_row(last_entry_split, last_entry_keys, chars)
  #   if (last_entry_keys[-1] == 64) && (last_entry_keys[-2] == 64)
  #     byebug
  #     add_new_character(last_entry_keys, chars)
  #   else
  #   # replace the second to last character with the incremented key
  #     last_entry_keys.map! do |key|
  #       #byebug
  #       if key == last_entry_keys[-1]
  #         #byebug
  #         chars.keys.first
  #       elsif key == last_entry_keys[-2] # incrementing the second to last one as long as its not 64
  #         #byebug
  #         chars.keys.first if key == 64
  #         key + 1
  #       end
  #     end
  #     #byebug

  #     short_link = last_entry_keys.map do |num|
  #       chars[num]
  #     end
  #     self.short_link = short_link.join("")
  #   end
  # end

  # def increment_short_url(last_entry_keys, chars) # increment the last character
  #   num = last_entry_keys.last
  #   last_entry_keys.pop
  #   last_entry_keys.push num + 1

  #   short_link = last_entry_keys.map {|num| chars[num]}

  #   self.short_link = short_link.join("")
  # end

  def map_values_to_keys(values, chars)
    values.map do |str|
      chars.key(str)
    end
  end

end
