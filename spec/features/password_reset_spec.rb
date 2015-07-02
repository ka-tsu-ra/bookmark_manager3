feature 'Password reset' do

  scenario 'requesting a password reset' do
    user = create(:user)
    sign_up(user)
    visit '/password_reset'
    fill_in 'Email', with: user.email
    click_button 'Reset password'
    user = User.first(email: user.email)
    expect(user.password_token).not_to be_nil
    expect(page).to have_content 'Check your emails'
  end
end
  # scenario 'resetting a password' do
  #   user = User.first
  #   user.password_token = 'token'
  #   user.save
  #
  #   visit "/users/password_reset/#{user.password_token}"
  #   expect(page.status_code).to eq 200
  #   expect(page).to have_content 'Enter a new password'
  # end
