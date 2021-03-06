require 'open-uri'

# #---- HOW TO GENERATE `drinks.json` FROM www.thecocktaildb.com/api

# #---- Generate `drinks_ids.json` first

# array = []

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

# categories.each do |category|
#   results = JSON.parse(open(category).read, symbolize_names: true)
#   results[:drinks].each do |result|
#     array << {
#       name: result[:strDrink],
#       id: result[:idDrink]
#     }
#   end
# end

# File.open("drinks_ids.json","w") do |f|
#   f.write(JSON.pretty_generate(array))
# end

# #---- Generate `drinks.json` from the `drinks_ids.json` file
# #---- NOTE: you must split up the api call in 50 or less JSON hash requests
# #           or it will be too slow and won't work

# array = []

# results = JSON.parse(File.read("drinks_ids.json"), symbolize_names: true)

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

# #---- Manually run this iteration for each of the results_# array above while
# #---- keeping the `array` in memory, waiting a couple of seconds before each
# #---- for best results

# results_11.each do |result|
#   cocktail_url = "https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=#{result[:id]}"
#   cocktail = JSON.parse(open(cocktail_url).read, symbolize_names: true)[:drinks][0]
#   array << cocktail
# end

# #---- Create the final JSON

# File.open("drinks.json","w") do |f|
#   f.write(JSON.pretty_generate(array))
# end

#---- SEEDING THE DATABASE

#---- Delete everything

puts 'Clearing database of Doses...'
Dose.destroy_all

puts 'Clearing database of Ingredients...'
Ingredient.destroy_all

puts 'Clearing database of Reviews...'
Review.destroy_all

puts 'Clearing database of Cocktails...'
Cocktail.destroy_all

results = JSON.parse(File.read("drinks.json"), symbolize_names: true)

# ---- Generate Ingredients

puts 'Generating new Ingredients...'

results.each do |result|
  (1..15).each do |n|
    name = result[:"strIngredient#{n}"]
    Ingredient.create(name: name) if name&.match?(/\w/)
  end
end

puts "Created #{Ingredient.count} ingredients in the database..."

#---- Generate Cocktails

puts 'Generating new Cocktails...'

results.each do |result|
  Cocktail.create(
    name: result[:strDrink]
  )
end

cloudinary_urls = JSON.parse(File.read("cloudinary_urls.json"), symbolize_names: true)

cloudinary_urls.each do |url|
  cocktail = Cocktail.find_by(name: url[:name])
  cocktail.remote_photo_url = url[:cloudinary_url]
  cocktail.save
end

puts "Created #{Cocktail.count} cocktails in the database..."

#---- Generate Doses

puts 'Generating new Doses...'

results.each do |result|
  cocktail = Cocktail.find_by(name: result[:strDrink])
  (1..15).each do |n|
    ingredient = Ingredient.find_by(name: result[:"strIngredient#{n}"])
    next unless ingredient

    dose = cocktail.doses.new(ingredient: ingredient)
    description = result[:"strMeasure#{n}"]
    dose.description = description if description&.match?(/\w/)
    dose.save
  end
end

puts "Created #{Dose.count} doses in the database..."

#---- Generate Reviews

puts 'Generating new Reviews...'

Cocktail.all.each do |cocktail|
  rand(5..10).times do
    cocktail.reviews.create(
      content: Faker::ChuckNorris.fact,
      rating: rand(0..5)
    )
  end
end

puts "Created #{Review.count} reviews in the database..."
puts "Enjoy!"

# #---- BONUS: GENERATE JSON WITH CLOUDINARY URLs from local db per Cocktail::name

# array = []

# Cocktail.all.each do |cocktail|
#   array << {
#     name: cocktail.name,
#     cloudinary_url: cocktail.photo.url
#   }
# end

# File.open('cloudinary_urls.json', 'w') do |f|
#   f.write(JSON.pretty_generate(array))
# end
