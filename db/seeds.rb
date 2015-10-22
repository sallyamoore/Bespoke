require 'csv'

CSV.foreach("db/users.csv", headers: true) do |row|
  User.create!(
    email: row[0],
    username: row[1],
    password: row[2],
    password_confirmation: row[3],
    provider: row[4],
    uid: row[5],
    activated: row[6],
    activated_at: Time.now
  )
end

CSV.foreach("db/locations.csv", headers: true) do |row|
  Location.create!(
    node_number: row[0],
    latitude: row[1],
    longitude: row[2],
    node_id: row[3]
  )
end

users = User.all
locations = Location.all
users.each do |user|
  user.locations << locations.sample([*0..locations.length].sample)
end
