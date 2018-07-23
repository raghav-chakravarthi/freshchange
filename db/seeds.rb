# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)



# Creating subscribers

Account.create(owner_name: "Raghav Vc", email: "raghav.chakravarthi@freshworks.com", team_name: "Freshcaller")
User.create(name: "Raghav", email: "raghav.chakravarthi@freshworks.com", admin: true, has_access: true, account_id: 1, created: true, password: "password")