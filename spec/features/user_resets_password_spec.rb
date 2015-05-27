require 'rails_helper'

feature 'User resets their password' do
  scenario 'click link in their email to reset password' do
    bob = Fabricate(:user)

    visit login_path
    click_link "Forgot Password?"
    fill_in "Email", with: bob.email
    click_button "Send Email"
    expect(page).to have_content "We have send an email with instruction to reset your password."
    
    open_email(bob.email)
    current_email.click_link "Reset My Password"
    expect(page).to have_content "Reset Your Password"

    fill_in "Password", with: 'password'
    click_button "Reset Password"
    expect(page).to have_content "Login"

    fill_in "Username", with: bob.username
    fill_in "Password", with: bob.password
    click_button "Login"
    expect(page).to have_content 'You have successfully log in'
    
    clear_email
  end
end