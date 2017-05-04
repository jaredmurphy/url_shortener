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

  # def generate_short_link 
  #   chars = get_chars_hash
  #   if !Url.last # if this is the first entry
  #      puts "THIS IS THE FIRST ENTRY"
  #      self.short_link = chars[1]
  #   else  # any other entry
  #     byebug if !Url.last.short_link
  #     last_entry = Url.last
  #     last_entry_split = last_entry.short_link.split("")
  #     last_entry_keys = map_values_to_keys(last_entry_split, chars)
      
  #     if (last_entry_keys.last < 64) 
      
  #       num = last_entry_keys.last 
  #       last_entry_keys.pop 
  #       last_entry_keys.push num + 1

  #       short_link = last_entry_keys.map do |num|
  #         chars[num]
  #       end
  #       self.short_link = short_link.join("")
  #     else # if it is 64

  #       last_entry_keys.push chars.keys.first
    
  #       puts "URL LAST ID #{Url.last.id} S LINK #{Url.last.short_link} LAST ENT KEYS #{last_entry_keys}"

  #       short_link = last_entry_keys.map do |num|
  #         chars[num]
  #       end
  #       self.short_link = short_link.join("")
  #     end 
  #   end
  # end

  def generate_short_link
    chars = get_chars_hash
    if !Url.last # if this is the first entry
       self.short_link = chars[1]
    else 
      last_entry = Url.last
      last_entry_split = last_entry.short_link.split("")
      last_entry_keys = map_values_to_keys(last_entry_split, chars)

      perumutations_left(last_entry_split, last_entry_keys, chars)
    end

    # self.short_link = loop do 
    #   random_string = SecureRandom.urlsafe_base64(5) 
    #   break random_string unless Url.exists?(short_link: random_string)
    # end
  end

  def add_new_character(last_entry_keys, chars) # adds a new character in the short_link string
    last_entry_keys[-1] = chars.keys.first
    last_entry_keys.push chars.keys.first
    
  #  new_entry_keys = last_entry_keys.map do |key|
  #     if key = last_entry_keys[-1]
  #       1
  #     elsif key = last_entry_keys[-2]
  #       1
  #     else 
  #       key
  #     end
  #   end
    short_link = last_entry_keys.map do |num|
      chars[num]
    end
    puts "add new character #{short_link.join("")}"
    self.short_link = short_link.join("")
  end

  def perumutations_left(last_entry_split, last_entry_keys, chars)
    if last_entry_keys.last == 64
      
      if last_entry_split.length == 1 # if this is the first time we're adding a new character
        
        puts "ADD NEW CHARACTER"
        add_new_character(last_entry_keys, chars)
      else 
        puts "MOVE TO NEXT ROW"
        move_to_next_row(last_entry_split, last_entry_keys, chars)
      end 
    elsif # last key is anytyihng other than 64
      
      #puts "#{last_entry_split}, #{last_entry_keys}, #{chars}"
      increment_short_url(last_entry_keys, chars)
    end
  end 

  def move_to_next_row(last_entry_split, last_entry_keys, chars)
   # byebug
    # last = last_entry_keys[-1]
    # second_last = last_entry_keys[-2]
    #new_second_last_key = second_last == 

    # replace last character with the first key on the new permutation
    # last_entry_keys.pop 
    # last_entry_keys.push chars.keys.first
    #byebug
    # replace the second to last character with the incremented key
    last_entry_keys.map! do |key|
      #byebug
      if key == last_entry_keys[-1]
        #byebug
         chars.keys.first
      elsif key == last_entry_keys[-2] # incrementing the second to last one as long as its not 64
        #byebug
         chars.keys.first if key == 64
         key + 1 
      end
    end 
    #byebug

    short_link = last_entry_keys.map do |num|
      chars[num]
    end
    self.short_link = short_link.join("")
  end

  def increment_short_url(last_entry_keys, chars) # increment the last character
    num = last_entry_keys.last 
    last_entry_keys.pop 
    last_entry_keys.push num + 1

    short_link = last_entry_keys.map {|num| chars[num]}
    
    self.short_link = short_link.join("")
  end


  

  

  def map_values_to_keys(values, chars)
    values.map do |str|
      chars.key(str)
    end
  end

end
