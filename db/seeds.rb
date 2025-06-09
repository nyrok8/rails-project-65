# frozen_string_literal: true

require 'faker'
require 'open-uri'

User.create!(
  name: 'nyrok8',
  email: 'nyrok8@gmail.com',
  admin: true
)

User.create!(
  name: 'vasiliqa13',
  email: 'vasiliqa13@gmail.com',
  admin: true
)

@users = Array.new(5) do
  User.create!(
    name: Faker::JapaneseMedia::OnePiece.unique.character,
    email: Faker::Internet.unique.email
  )
end

@categories = Array.new(5) do
  Category.create!(name: Faker::Commerce.unique.department(max: 1))
end

def create_bulletin(state)
  bulletin = Bulletin.new(
    title: Faker::Commerce.unique.product_name,
    description: Faker::Lorem.paragraph(sentence_count: 10),
    user: @users.sample,
    category: @categories.sample,
    state: state
  )

  uuid = SecureRandom.uuid
  url = Faker::Avatar.image(slug: uuid, size: '600x600')
  io = URI.parse(url).open
  bulletin.image.attach(
    io: io,
    filename: "bulletin_#{uuid}.jpg",
    content_type: io.content_type
  )

  bulletin.save!
end

50.times do
  create_bulletin(:published)
end

20.times do
  create_bulletin(:under_moderation)
end

10.times do
  create_bulletin(:draft)
end

5.times do
  create_bulletin(:rejected)
end

5.times do
  create_bulletin(:archived)
end
