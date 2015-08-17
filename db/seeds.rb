# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Out of the box, this creates the following tables in the restaurant:
# * 3 tables that can seat 2 people.
# * 5 tables that can seat 4 people.
# * 3 tables that can seat 6 people.
# * 2 tables that can seat 8 people.
#
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
