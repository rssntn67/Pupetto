# By using the symbol ':user', we get Factory Girl to simulate the User model.
Factory.define :user do |user|
  user.name                  "Antonio Russo"
  user.email                 "antonio@opennms.it"
  user.password              "kloss1"
  user.password_confirmation "kloss1"
end