require 'open-uri'

#---- Delete everything

puts 'Clearing database of Ingredients...'
Ingredient.destroy_all

puts 'Clearing database of Doses...'
Dose.destroy_all

puts 'Clearing database of Reviews...'
Review.destroy_all

puts 'Clearing database of Cocktails...'
Cocktail.destroy_all

#---- Generate Ingredients

url = 'https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list'
buffer = open(url).read
results = JSON.parse(buffer, symbolize_names: true)

puts 'Generating new ingredients...'

results[:drinks].each do |result|
  Ingredient.create!(name: result[:strIngredient1])
end

puts "Created #{Ingredient.count} ingredients in the database..."

#---- Generate Cocktails

url = 'https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list'
buffer = open(url).read
results = JSON.parse(buffer, symbolize_names: true)

puts 'Generating new ingredients...'

results[:drinks].each do |result|
  Ingredient.create!(name: result[:strIngredient1])
end

puts "Created #{Ingredient.count} ingredients in the database..."

https://www.thecocktaildb.com/api/json/v1/1/list.php?c=list
