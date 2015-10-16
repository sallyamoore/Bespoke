require 'csv'

CSV.foreach("db/users.csv", headers: true) do |row|
  User.create!(
    email: row[0],
    username: row[1],
    password: row[2],
    password_confirmation: row[3],
    provider: row[4],
    uid: row[5]
  )
end

CSV.foreach("db/locations.csv", headers: true) do |row|
  Location.create!(node_number: row[0], latitude: row[1], longitude: row[2])
end

users = User.all
locations = Location.all
users.each do |user|
  user.locations << locations.sample([*0..20].sample)
end
