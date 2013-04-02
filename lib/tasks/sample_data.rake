namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    admin = User.create!(name: "Example User",
                 email: "test@room.org",
                 password: "12345678",
                 password_confirmation: "12345678")
    admin.toggle!(:admin)
    99.times do |n|
      name  = Faker::Name.name
      email = "test#{n+1}@room.org"
      password  = "password"
      User.create!(name: name,
                   email: email,
                   password: "12345678",
                   password_confirmation: "12345678")
    end
  end
end