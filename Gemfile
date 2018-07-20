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

if ENV['TRAVIS']
  gem 'shared_platform',
    branch: 'master',
    shared: 'aeberlin/shared_platform'
else
  gem 'shared_platform', path: '../../'
end
