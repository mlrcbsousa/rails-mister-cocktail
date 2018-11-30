require 'open-uri'

# #---- Generate drinks.json

# results = JSON.parse(File.read("idDrinks.json"), symbolize_names: true)

# results_1 = results[0..49]
# results_2 = results[50..99]
# results_3 = results[100..149]
# results_4 = results[150..199]
# results_5 = results[200..249]
# results_6 = results[250..299]
# results_7 = results[300..349]
# results_8 = results[350..399]
# results_9 = results[400..449]
# results_10 = results[450..499]
# results_11 = results[500..546]

# array = []

# results_11.each do |result|
#   cocktail_url = "https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=#{result[:id]}"
#   cocktail = JSON.parse(open(cocktail_url).read, symbolize_names: true)[:drinks][0]
#   array << cocktail
# end

# File.open("drinks.json","w") do |f|
#   f.write(JSON.pretty_generate(array))
# end

#---- Delete everything

puts 'Clearing database of Doses...'
Dose.destroy_all

# puts 'Clearing database of Ingredients...'
# Ingredient.destroy_all

puts 'Clearing database of Reviews...'
Review.destroy_all

# puts 'Clearing database of Cocktails...'
# Cocktail.destroy_all

# #---- Generate Ingredients

# url = 'https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list'
# results = JSON.parse(open(url).read, symbolize_names: true)

# puts 'Generating new Ingredients...'

# results[:drinks].each do |result|
#   Ingredient.create!(name: result[:strIngredient1])
# end

# puts "Created #{Ingredient.count} ingredients in the database..."

# #---- Generate Cocktails

# # all the categories
# categories = [
#   'https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=Ordinary_Drink',
#   'https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=Cocktail',
#   'https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=Milk%20/%20Float%20/%20Shake',
#   'https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=Other/Unknown',
#   'https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=Cocoa',
#   'https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=Shot',
#   'https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=Coffee%20/%20Tea',
#   'https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=Homemade%20Liqueur',
#   'https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=Punch%20/%20Party%20Drink',
#   'https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=Beer',
#   'https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=Soft%20Drink%20/%20Soda'
# ]

# puts 'Generating new Cocktails...'

# categories.each do |category|
#   results = JSON.parse(open(category).read, symbolize_names: true)
#   results[:drinks].each do |result|
#     Cocktail.create(
#       name: result[:strDrink],
#       picture_url: result[:strDrinkThumb]
#     )
#   end
# end

# puts "Created #{Cocktail.count} cocktails in the database..."

#---- Generate Doses

# puts 'Generating new Doses...'

results = JSON.parse(File.read("drinks.json"), symbolize_names: true)

results.each do |result|
  cocktail = Cocktail.find_by(name: result[:strDrink])

  (1..15).each do |n|
    ingredient = Ingredient.find_by(name: result[:"strIngredient#{n}"])
    if ingredient
      cocktail.doses.create(
        description: result[:"strMeasure#{n}"],
        ingredient: ingredient
      )
    elsif result[:"strIngredient#{n}"] && result[:"strIngredient#{n}"].match?(/\w/)
      ingredient = Ingredient.create(name: result[:"strIngredient#{n}"])
      cocktail.doses.create(
        description: result[:"strMeasure#{n}"],
        ingredient: ingredient
      )
    end
  end
end

# puts "Created #{Dose.count} doses in the database..."
# puts "Enjoy!"
