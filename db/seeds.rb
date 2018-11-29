require 'open-uri'
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

url = 'https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list'
buffer = open(url).read
results = JSON.parse(buffer, symbolize_names: true)

puts 'Clearing databaseof Ingredients...'
Ingredient.destroy_all

puts 'Generating new ingredients...'

results[:drinks].each do |result|
  Ingredient.create!(name: result[:strIngredient1])
end

puts "Created #{Ingredient.count} ingredients in the database..."
