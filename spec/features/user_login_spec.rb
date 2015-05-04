require 'rails_helper'

feature "User logs in" do
  scenario "with valid account" do
    bob = Fabricate(:user)

    visit login_path

    fill_in 'Username', with: bob.username
    fill_in 'Password', with: bob.password
    click_button 'Login'

    expect(page).to have_content bob.username
  end

  scenario "with invalid account" do
    visit login_path

    fill_in 'Username', with: 'invalid username'
    fill_in 'Password', with: 'invalid password'
    click_button 'Login'

    expect(page).to have_content 'Login Page'
  end
end