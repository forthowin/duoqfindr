require 'rails_helper'

feature 'user sends a message and the other replys' do
  scenario 'with valid inputs' do
    bob = Fabricate(:user)
    jim = Fabricate(:user)
    sign_in(bob)

    fill_in 'radius', with: 10
    click_button 'Search'
    find("a[href='/users/#{jim.slug}']").click
    expect(page).to have_content jim.username

    fill_in 'Subject', with: 'Looking for support'
    fill_in 'Body', with: 'Do you want to play?'
    click_button 'Send'
    expect(page).to have_content 'Message sent!'

    sign_out
    sign_in(jim)
    visit conversations_path

    click_link 'Looking for support'
    fill_in 'reply_body', with: 'Sure!'
    click_button 'Reply'
    expect(page).to have_content 'Message sent!'
    expect(page).to have_content 'Sure!'

    sign_out
    sign_in(bob)
    visit conversations_path
    expect(page).to have_content 'Looking for support'
  end

  scenario 'with empty subject or body' do
    bob = Fabricate(:user)
    jim = Fabricate(:user)
    sign_in(bob)

    fill_in 'radius', with: 10
    click_button 'Search'
    find("a[href='/users/#{jim.slug}']").click

    fill_in 'Body', with: 'Wanna play?'
    click_button 'Send'
    expect(page).to have_content 'Subject and body must be present.'

    fill_in 'Subject', with: 'Looking for support'
    fill_in 'Body', with: 'Wanna play?'
    click_button 'Send'

    sign_out
    sign_in(jim)
    visit conversations_path

    click_link 'Looking for support'
    click_button 'Reply'
    expect(page).to have_content "Reply body can't be blank"
  end
end