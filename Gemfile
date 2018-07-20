source 'https://rubygems.org'

def setup_github_oauth!
  return unless File.exists?('.github_oauth')
  ENV['GITHUB_OAUTH_TOKEN'] ||= File.read('.github_oauth').strip
end

def private_github_uri(repo)
  setup_github_oauth!

  return "git@github.com:#{repo}.git" unless ENV['GITHUB_OAUTH_TOKEN']

  "https://#{ENV['GITHUB_OAUTH_TOKEN']}:x-oauth-basic@github.com/#{repo}.git"
end

git_source(:github) { |repo| "https://github.com/#{repo}.git" }
git_source(:private) { |repo| private_github_uri(repo) }

git_source(:shared) do |repo|
  name = repo.split('/').last

  if Dir.exists?("../../../#{name}")
    File.expand_path("../../../#{name}")
  else
    private_github_uri(repo)
  end
end

# gemspec

# group :linting do
#   gem 'activerecord-nulldb-adapter'
#   gem 'astrolabe'
#   gem 'haml_lint'
#   gem 'rubocop'
#   gem 'scss_lint'
# end

# group :test do
#   gem 'capybara-screenshot'
#   gem 'capybara'
#   gem 'codeclimate-test-reporter'
#   gem 'fivemat'
#   gem 'gherkin'
#   gem 'poltergeist'
#   # gem 'rb-readline'
#   gem 'rspec-page-regression'
#   gem 'rspec-rails'
#   gem 'simplecov'
#   gem 'timecop'
#   gem 'turnip'
#   gem 'webmock'
#
#   gem 'rspec-retry',
#     branch:  'store-attempted-retries-in-example-metadata',
#     github:  'aeberlin/rspec-retry',
#     require: false
# end

# group :development, :staging do
#   gem 'better_errors',
#     branch: 'pry_repl_fixes',
#     github: 'aeberlin/better_errors'
# end

# group :development, :test, :staging do
#   gem 'woo',
#     branch: 'render_with_context',
#     github: 'aeberlin/woo'
# end

# gem 'simple_form',
#   branch: 'css_on_wrapper_when_valid',
#   github: 'aeberlin/simple_form'

# gem 'sync',
#   branch: 'stomp_adapter',
#   github: 'aeberlin/sync',
#   ref:    '80bda8ae4accce8757eb64b57e238b183bca8179'

gem 'shared_platform',
  branch: 'master',
  shared: 'aeberlin/shared_platform'
