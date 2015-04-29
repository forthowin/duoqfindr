Fabricator(:user) do
  username { Faker::Internet.user_name }
  password 'password'
  role 'Top'
  tier 'Diamond'
end