# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Url.destroy_all
prefix = "http://"
suffix = ".com"
arr = []
i = 1 

while i < 4300
    str = prefix + i.to_s + suffix
    arr.push({full_link: str})
    i += 1
end

urls = Url.create(arr)

puts "#{Url.count} urls created"