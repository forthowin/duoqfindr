require 'rails_helper'

feature 'User edit profile' do
  scenario 'with valid input' do
    bob = Fabricate(:user)
    sign_in(bob)
    visit edit_user_path bob

    fill_in 'Bio', with: 'I am the best!'
    fill_in 'Email', with: 'bob@example.com'
    fill_in 'Password', with: 'newpassword'
    click_button 'Update'
    visit logout_path

    visit login_path
    fill_in 'Username', with: bob.username
    fill_in 'Password', with: 'newpassword'
    click_button 'Login'

    visit user_path bob
    expect(page).to have_content 'I am the best!'
  end
end