require 'machinist/active_record'

# Add your blueprints here.
#
# e.g.
#   Post.blueprint do
#     title { "Post #{sn}" }
#     body  { "Lorem ipsum..." }
#   end
#
User.blueprint do
  email { Faker::Internet.email }
  password { 'password'}
end

Group.blueprint do
  owner
  name { Faker::Name.name}
end
