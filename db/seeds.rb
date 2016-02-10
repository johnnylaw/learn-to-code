# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Quote.create(
  body: "Health nuts are going to feel stupid one day, lying around in hospitals dying of nothing.",
  author: "Redd Foxx",
  year: nil,
  verified: true
)
Quote.create(
  body: "Wherever you go, there you are.",
  author: "Buckaroo Bonzai",
  year: 1997,
  verified: false
)
puts "Count of quotes in the database: #{Quote.count}"
puts "Attributes of first quote in the database:\n#{Quote.first.attributes}"
