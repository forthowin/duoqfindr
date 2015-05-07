require 'rails_helper'

feature 'User registers' do
  scenario "with valid inputs" do
    visit register_path

    fill_in 'Username', with: 'l33tgamerz'
    fill_in 'Email', with: 'l33tgamerz@gaming.com'
    select 'Jungle', from: 'Role'
    select 'Master', from: 'Tier'
    fill_in 'Password', with: 'password'
    click_button 'Register'

    expect(page).to have_content 'l33tgamerz'
  end

  scenario 'with invalid inputs' do
    visit register_path

    click_button 'Register'

    expect(page).to have_content 'Registration Page'
  end
end