require 'rails_helper'

describe 'visitor can create an account' do
  before :each do
    @email = 'jimbob@aol.com'
    @first_name = 'Jim'
    @last_name = 'Bob'
    @password = 'password'
    @password_confirmation = 'password'
  end

  it 'must accept email activation code' do
    visit '/'

    click_on 'Sign In'

    expect(current_path).to eq(login_path)

    click_on 'Sign up now.'

    expect(current_path).to eq(new_user_path)

    fill_in 'user[email]', with: @email
    fill_in 'user[first_name]', with: @first_name
    fill_in 'user[last_name]', with: @last_name
    fill_in 'user[password]', with: @password
    fill_in 'user[password_confirmation]', with: @password

    click_on'Create Account'

    expect(current_path).to eq(dashboard_path)

    expect(page).to have_content(@email)
    expect(page).to have_content(@first_name)
    expect(page).to have_content(@last_name)
    expect(page).to_not have_content('Sign In')

    msg = 'This account has not yet been activated. Please check your email.'

    expect(page).to have_content(msg)
    expect(page).to have_content("Logged in as #{@email}")

    # As a non-activated user
    # When I check my email for the registration email
    # I should see a message that says "Visit here to activate your account."
    # And when I click on that link
    source = ActionMailer::Base.deliveries.last.body.parts[0].body.raw_source
    begin_link = source.index('href=') + 5
    end_link = source.index('>', begin_link) - 1
    link = source[begin_link..end_link]
    begin_uri = link.index('.com') + 4

    link_to_click = link[begin_uri..-1].delete('"')

    visit '/activate/123456'
    expect(page).to have_content('Sorry, invalid activation code entered.')

    visit link_to_click

    activation_email_code = Activation.first.email_code
    # visit activation_path(activation_email_code)

    # Then I should be taken to a page that says "Thank you! Your account is now activated."
    expect(current_path).to eq(activate_path(activation_email_code))
    expect(page).to have_content('Thank you! Your account is now activated.')

    # And when I visit "/dashboard"
    # Then I should see "Status: Active"
    visit dashboard_path
    expect(page).to have_content('Status: Active')
  end
end
