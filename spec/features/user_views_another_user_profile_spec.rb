require 'rails_helper'

feature 'User views another user profile' do
  scenario 'with a linked account', :vcr do
    bob = Fabricate(:user, latitude: 0, longitude: 0)
    jim = Fabricate(:user, latitude: 0, longitude: 0, summoner_id: 23472148, region: 'na')

    sign_in(bob)

    fill_in 'radius', with: 10
    click_button 'Search'

    find("a[href='/users/#{jim.slug}']").click

    expect(page).to have_content jim.username
    expect(page).to have_content 'Wins'
    expect(page).to have_content 'Losses'
    expect(page).not_to have_content 'Main Role'
  end

  scenario 'with a non-linked account', :vcr do
    bob = Fabricate(:user, latitude: 0, longitude: 0)
    jim = Fabricate(:user, latitude: 0, longitude: 0, summoner_id: 23472148, region: 'na')
    
    sign_in(jim)

    fill_in 'radius', with: 10
    click_button 'Search'

    find("a[href='/users/#{bob.slug}']").click

    expect(page).to have_content bob.username
    expect(page).to have_content 'Main Role'
    expect(page).to have_content 'Tier'
    expect(page).not_to have_content 'Wins'
  end
end