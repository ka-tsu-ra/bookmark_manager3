feature 'User sign out' do
  #
  # before(:each) do
  #   @user = create(:user) # uses factory girl user
  # end
  # COULD USE THIS INSTEAD OF LET BUT HAVE TO CHANGE ALL USERS TO @USER

  let(:user) do
    create(:user)
  end

  scenario 'while being signed in' do
    sign_in(user)
    click_button 'Sign out'
    expect(page).to have_content('goodbye!')
    expect(page).not_to have_content("Welcome, #{user.email}")
  end
end
