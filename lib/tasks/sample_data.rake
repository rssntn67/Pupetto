namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    make_users
    make_microposts
    make_relationships
    make_workrelations
    make_menus
    make_deliveries
    make_accounts
    make_orders
  end
end

def make_users
  admin = User.create!(:name => "Example User",
               :email => "example@railstutorial.org",
               :password => "foobar",
               :password_confirmation => "foobar")
  admin.toggle!(:admin)

  99.times do |n|
    name  = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    password  = "password"
    User.create!(:name => name,
                 :email => email,
                 :password => password,
                 :password_confirmation => password)
  end
end

def make_microposts
  User.all(:limit => 6).each do |user|
    50.times do
      content = Faker::Lorem.sentence(5)
      user.microposts.create!(:content => content)
    end
  end
end

def make_relationships
  users = User.all
  user  = users.first
  following = users[1..50]
  followers = users[3..40]
  following.each { |followed| user.follow!(followed) }
  followers.each { |follower| follower.follow!(user) }
end

def make_workrelations
  users = User.all
  user1  = users.first
  user2  = users.second
  user3  = users.third
  users[61..65].each { |employer| user1.employ!(employer) }
  users[66..69].each { |employer| user2.employ!(employer) }
  users[71..80].each { |employer| user3.employ!(employer) }
end

def make_menus
  users = User.all
  users[0..3].each do |user|
    10.times do |n|
      content = "#{n+1} main voice"
      user.menus.create!(:content => content)
    end
  end
end

def make_deliveries
    Menu.all.each do |menuitem|
      menuitem.deliveries.create!(:name => "piatto 1", :descr => "bla bla bla", :price => 10)
      menuitem.deliveries.create!(:name => "piatto 2", :descr => "bla bla bla", :price => 20)
      menuitem.deliveries.create!(:name => "piatto 3", :descr => "bla bla bla", :price => 30)
    end
end

def make_accounts
    users = User.all
    owner = users.first
    users[61..61].each { |employer| employer.accounts.create!(:owner_id => owner.id, :table => "Rosa", :guests => 10) }
    users[62..62].each { |employer| employer.accounts.create!(:owner_id => owner.id, :table => "Margherita", :guests => 6) }
    users[63..63].each { |employer| employer.accounts.create!(:owner_id => owner.id, :table => "Giaggiolo", :guests => 4) }
end

def make_orders
    users = User.all  
    users[61..65].each { |employer| employer.orders.create!(:account_id => 1, :delivery_id => 1) }
    users[61..65].each { |employer| employer.orders.create!(:account_id => 1, :delivery_id => 2) }
    users[61..63].each { |employer| employer.orders.create!(:account_id => 1, :delivery_id => 3) }
    users[61..64].each { |employer| employer.orders.create!(:account_id => 2, :delivery_id => 2) }
    users[61..63].each { |employer| employer.orders.create!(:account_id => 3, :delivery_id => 3) }
end
