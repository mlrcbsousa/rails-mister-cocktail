# Cloudinary::Uploader.upload("logo-mister-cocktail.png",
#   :folder => "lewagon/mistercocktails/logo/", :public_id => "logo-mister-cocktail", :overwrite => true)


@reviews = cocktail.reviews

reviews = cocktail.reviews
reviews.inject(0) { |sum, n| sum + n.rating } / reviews.count
