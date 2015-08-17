# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

3.times do
  Table.create(seats: 2)
end

5.times do
  Table.create(seats: 4)
end

3.times do
  Table.create(seats: 6)
end

2.times do
  Table.create(seats: 8)
end
