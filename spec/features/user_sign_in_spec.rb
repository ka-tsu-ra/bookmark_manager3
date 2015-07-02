feature 'User sign in' do

  # let(:user) do
  #   create(:user)
  # end

  scenario 'with correct credentials' do
    user = create(:user)
    sign_in(user)
    expect(page).to have_content "Welcome, #{user.email}"
  end

end
