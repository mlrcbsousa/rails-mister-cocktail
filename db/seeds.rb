require 'open-uri'

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

puts 'Generating new Doses...'

Cocktail.all.each do |cocktail|
  name = cocktail.name
  cocktail_url = "https://www.thecocktaildb.com/api/json/v1/1/search.php?s=#{name}"
  cocktail_json = JSON.parse(open(cocktail_url).read, symbolize_names: true)[:drinks][0]

  n = 1
  while cocktail_json[:"strMeasure#{n}"] && cocktail_json[:"strMeasure#{n}"].match?(/\w/) && cocktail_json[:"strIngredient#{n}"] && cocktail_json[:"strIngredient#{n}"].match?(/\w/)

    # then validate ingredients and build Dose instances
    ingredient = Ingredient.find_by(name: cocktail_json[:"strIngredient#{n}"])
    if ingredient
      cocktail.doses.create(
        description: cocktail_json[:"strMeasure#{n}"],
        ingredient: ingredient
      )
    end
    n += 1
  end

end

puts "Created #{Dose.count} doses in the database..."
puts "Enjoy!"
