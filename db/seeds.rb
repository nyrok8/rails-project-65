# frozen_string_literal: true

require 'faker'

category1 = Category.create(name: 'Одежда')
category2 = Category.create(name: 'Электроника')
category3 = Category.create(name: 'Мебель')
category4 = Category.create(name: 'Посуда')

5.times do
  User.create!(
    name: Faker::Games::Witcher.character,
    email: Faker::Internet.unique.email,
    admin: false
  )
end

bulletins_data = [
  { title: 'Бокал',        category: category4, image: 'glass.jpg' },
  { title: 'Шейвер',       category: category2, image: 'shaver.jpg' },
  { title: 'Стул',         category: category3, image: 'chair.jpg' },
  { title: 'Шорты',        category: category1, image: 'shorts.jpg' },
  { title: 'Воздуходувка', category: category2, image: 'blower.jpg' },
  { title: 'Видеокарта',   category: category2, image: 'video_card.jpg' }
]

bulletins_data.each do |data|
  bulletin = Bulletin.new(
    title: data[:title],
    description: Faker::Lorem.paragraph(sentence_count: 10),
    category: data[:category],
    user: User.order('RANDOM()').first
  )

  image_path = Rails.root.join('db/seed_images', data[:image])
  bulletin.image.attach(
    io: image_path.open,
    filename: data[:image],
    content_type: 'image/jpeg'
  )

  bulletin.save!
end
