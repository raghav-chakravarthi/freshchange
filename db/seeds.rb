# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)



# Creating subscribers

Subscriber.create(name: "Raghav", email: "raghav.chakravarthi@freshworks.com")
Subscriber.create(name: "Ashwin", email: "ashwin.elangovan@freshworks.com")
Subscriber.create(name: "Gauri", email: "gauri.singhal@freshworks.com")

# Creating websites

Website.create(url: "www.freshcaller.com", content: "", subscriber: Subscriber.first)
Website.create(url: "www.freshchat.com", content: "", subscriber: Subscriber.second)
Website.create(url: "www.freshdesk.com", content: "", subscriber: Subscriber.first)
Website.create(url: "www.freshservice.com", content: "", subscriber: Subscriber.third)