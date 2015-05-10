Fabricator(:user) do
  username { Faker::Internet.user_name }
  email { Faker::Internet.email}
  password 'password'
  role 'Top'
  tier 'Diamond'
  longitude 0
  latitude 0
end