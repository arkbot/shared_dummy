describe 'Routes', js: true, type: :feature do
  let(:uri) { '/' }

  before(:all) do
    Bundler.with_clean_env { `cd #{Rails.root} && RAILS_ENV=test bundle exec rake locomotive:bootstrap:force` }
  end

  before { visit(uri) }

  it '/' do
    expect(page).to have_content 'Lorem ipsum'
  end

  context '/index' do
    let(:uri) { '/index' }

    it '/' do
      expect(page).to have_content 'Lorem ipsum'
    end
  end

  context '/locomotive' do
    context '/sign_in' do
      let(:uri) { '/locomotive' }

      it '/' do
        expect(page).to have_content 'Sign in'

        fill_in 'Email',    with: AppConfig.deploy[Rails.env].email
        fill_in 'Password', with: AppConfig.deploy[Rails.env].password

        click_button 'Sign in'

        expect(page).to have_content('Signed in successfully.')
      end
    end
  end

  context '/public' do
    let(:uri) { '/public' }

    it '/' do
      expect(page).to have_content 'Lorem ipsum'
    end

    context '/index' do
      let(:uri) { '/public/index' }

      it '/' do
        expect(page).to have_content 'Lorem ipsum'
      end
    end
  end
end
