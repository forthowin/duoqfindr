require 'rails_helper'

feature 'User verify their league account and update their profile', js: true do
  scenario 'with correct info' do
    bob = Fabricate(:user)
    sign_in(bob)

    visit edit_user_path(bob)

    click_button 'Generate Token'
    token = '3C754E62'
    bob.update_column(:account_token, token)

    fill_in 'Summoner Name', with: 'forthowin'
    select 'na', from: '_region'
    click_button 'Verify Account'

    expect(page).to have_content 'Your account was linked successfully!'
    expect(page).not_to have_content 'Generate Token'
  end

  scenario 'with incorrect info' do
    bob = Fabricate(:user)
    sign_in(bob)

    visit edit_user_path(bob)

    click_button 'Generate Token'

    fill_in 'Summoner Name', with: 'forthowin'
    select 'na', from: '_region'
    click_button 'Verify Account'

    expect(page).to have_content 'Token did not match or runepage has not been updated yet. Verify account again in a bit.'
  end
end