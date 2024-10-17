# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end



# Generar 100 Posts
until Post.count >= 100 do
  Post.create(
    image: Faker::Avatar.image(slug: "my-own-slug", size: "50x50"),
    title: Faker::Book.title,
    description: Faker::Lorem.paragraph_by_chars(number: 200, supplemental: false)
  )
end

# Generar 20 Users
i = 0
until User.count >= 20 do
  User.create(
    email: "test#{i}@gmail.com", # Agregué ".com" para un formato de correo válido
    password: "asdasdasd",
    password_confirmation: "asdasdasd" # Cambié la sintaxis para que sea consistente
  )
  i += 1
end

# Obtener todos los Posts y Users
posts = Post.all
users = User.all

# Generar 1000 Comments
until Comment.count >= 1000 do
  Comment.create(
    content: Faker::Lorem.paragraph_by_chars(number: 200, supplemental: false),
    post_id: posts.sample.id,
    user_id: users.sample.id
  )
end

