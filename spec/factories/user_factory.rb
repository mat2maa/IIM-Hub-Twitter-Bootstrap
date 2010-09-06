Factory.define :user do |u|
  u.login {Faker::Name.first_name}
  u.enabled true
  u.email {Faker::Internet.email}
  u.password "password"
  u.password_confirmation "password"
end

Factory.define :admin, :class => User do |u|
  u.login {Faker::Name.first_name}
  u.enabled true
  u.email {Faker::Internet.email}
  u.password "password"
  u.password_confirmation "password"
  u.roles [:administrator]
end