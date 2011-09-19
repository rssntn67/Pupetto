# By using the symbol ':user', we get Factory Girl to simulate the User model.
Factory.define :user do |user|
  user.name                  "Antonio Russo"
  user.email                 "antonio@opennms.it"
  user.password              "kloss1"
  user.password_confirmation "kloss1"
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end

Factory.define :micropost do |micropost|
  micropost.content "Foo bar"
  micropost.association :user
end

Factory.define :menu do |menu|
  menu.content "Foo bar"
  menu.association :user
end

Factory.define :delivery do |delivery|
  delivery.name                  "Cotolette alla Milanese"
  delivery.descr                 "Cotolette di carne di vitello impanate e fritte"
  delivery.price                 10
  delivery.association           :menu
end

Factory.define :account do |account|
  account.table                  "Rosa"
  account.guests                 4 
  account.association           :employer
  account.association           :owner
end
