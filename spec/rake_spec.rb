describe 'Rake Tasks', js: false do
  DEV_RAKE_OUTPUT = Bundler.with_clean_env { `cd #{Rails.root} && RAILS_ENV=development bundle exec rake --tasks --all` }
  TEST_RAKE_OUTPUT = Bundler.with_clean_env { `cd #{Rails.root} && RAILS_ENV=test bundle exec rake --tasks --all` }
  PROD_RAKE_OUTPUT = Bundler.with_clean_env { `cd #{Rails.root} && RAILS_ENV=production bundle exec rake --tasks --all` }

  ALL_TASKS = %w[
    coffee_lint
    haml_lint
    linters:all
    npm:install
    rubocop
    scss_lint
  ].freeze

  DEV_TASKS = (ALL_TASKS - ['npm:install']).freeze
  PROD_TASKS = (ALL_TASKS - DEV_TASKS).freeze

  # it 'enhances assets:precompile' do
  #   pending
  #
  #   require 'rake'
  #
  #   Rake.application.rake_require 'shared_platform/tasks/assets'
  #   Rake::Task.define_task(:environment)
  #
  #   expect(Rake::Task['app:npm:install:clean']).to receive(:invoke).once
  #   expect(Rake::Task['app:assets:manifests:clone']).to receive(:invoke).once
  #
  #   Rake::Task['app:assets:precompile'].invoke
  # end

  context 'in development' do
    ALL_TASKS.each do |task|
      it "injects the development task: '#{task}'" do
        expect(DEV_RAKE_OUTPUT).to match(task)
      end
    end
  end

  context 'in test' do
    ALL_TASKS.each do |task|
      it "injects the development task: '#{task}'" do
        expect(TEST_RAKE_OUTPUT).to match(task)
      end
    end
  end

  context 'in production' do
    DEV_TASKS.each do |task|
      it "omits the development task: '#{task}'" do
        expect(PROD_RAKE_OUTPUT).not_to match(task)
      end
    end

    PROD_TASKS.each do |task|
      it "injects the production task: '#{task}'" do
        expect(PROD_RAKE_OUTPUT).to match(task)
      end
    end
  end
end
