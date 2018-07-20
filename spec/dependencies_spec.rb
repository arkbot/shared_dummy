require 'json'

def compute_injections(environment)
  Dir.chdir(Rails.root)

  command = %{
    def _dependency_injected?(constant_string)
      puts Object.const_get(constant_string).to_s
    rescue NameError
      nil
    end
  }

  SharedPlatform::ALL_DEPENDENCIES.each do |_name, gem_meta|
    command += "\n"
    command += "_dependency_injected?('#{gem_meta[:entry]}')"
  end

  # `BUNDLE_GEMFILE=Gemfile RAILS_ENV=#{environment} ./bin/bundle exec rails runner "#{command}"`
  Bundler.with_clean_env { `cd #{Rails.root} && RAILS_ENV=#{environment} bundle exec #{Rails.root.join('bin/rails')} runner "#{command}"` }
end

INJECTED_DEPENDENCIES = {
  development: compute_injections(:development),
  linting:     compute_injections(:linting),
  test:        compute_injections(:test),
  staging:     compute_injections(:staging),
  production:  compute_injections(:production)
}.freeze

describe 'Dependencies', js: false do
  shared_examples_for 'a dependency set' do |matcher_method, dependency_hash, *environments|
    message = matcher_method.to_s =~ /not/ ? 'omits the dependency' : 'injects the dependency'

    environments.each do |environment|
      context "in #{environment} environment" do
        dependency_hash.each do |gem_name, gem_meta|
          it "#{message}: '#{gem_name}'" do
            matcher = match(gem_meta[:entry])
            expect(INJECTED_DEPENDENCIES[environment]).send(matcher_method, matcher)
          end
        end
      end
    end
  end

  shared_examples_for 'an inclusion set' do |dependency_hash, *environments|
    it_behaves_like 'a dependency set', :to, dependency_hash, *environments
  end

  shared_examples_for 'an exclusion set' do |dependency_hash, *environments|
    it_behaves_like 'a dependency set', :not_to, dependency_hash, *environments
  end

  shared_examples_for 'a js-dependency set' do |config_file, asset_folder|
    dependencies = JSON.parse(File.read(Rails.root.join(config_file)))['dependencies']

    dependencies.each do |dependency_name, _meta|
      it "includes: '#{dependency_name}'" do
        folder = Rails.root.join("#{asset_folder}/#{dependency_name}")
        expect(Dir.exist?(folder)).to be_truthy
        expect(Dir["#{folder}/**/*"]).not_to be_empty
      end
    end
  end

  # before(:all) { `cd #{Rails.root} && bundle exec rake assets:precompile` }
  # after(:all) { `cd #{Rails.root} && bundle exec rake assets:clobber:all` }

  context '#JS_DEPENDENCIES' do
    it 'uses spec/dummy/ as Rails.root' do
      expect(Rails.root.to_s).to eq("#{SharedPlatform::Engine.root}/spec/dummy")
    end

    it 'pulls npm components' do
      expect(File.exist?(Rails.root.join('package.json'))).to be_truthy
      expect(Dir.exist?(Rails.root.join('node_modules'))).to be_truthy
    end

    it_behaves_like 'a js-dependency set', 'package.json', 'node_modules'
  end

  context '#RUNTIME_DEPENDENCIES' do
    it_behaves_like 'an inclusion set',
      SharedPlatform::RUNTIME_DEPENDENCIES,
      :development,
      :linting,
      :test,
      :staging,
      :production
  end

  # context '#OPTIONAL_DEPENDENCIES' do
  #   it_behaves_like 'an inclusion set',
  #     SharedPlatform::OPTIONAL_DEPENDENCIES,
  #     :development,
  #     :linting,
  #     :test,
  #     :staging,
  #     :production
  # end

  context '#DEVELOPMENT_DEPENDENCIES' do
    it_behaves_like 'an inclusion set',
      SharedPlatform::DEVELOPMENT_DEPENDENCIES,
      :development,
      :test,
      :staging

    it_behaves_like 'an exclusion set',
      SharedPlatform::DEVELOPMENT_DEPENDENCIES,
      :linting,
      :production
  end

  context '#TEST_DEPENDENCIES' do
    it_behaves_like 'an inclusion set',
      SharedPlatform::TEST_DEPENDENCIES,
      :test

    it_behaves_like 'an exclusion set',
      SharedPlatform::TEST_DEPENDENCIES,
      :development,
      :linting,
      :staging,
      :production
  end

  context '#LINTING_DEPENDENCIES' do
    it_behaves_like 'an inclusion set',
      SharedPlatform::LINTING_DEPENDENCIES,
      :linting

    it_behaves_like 'an exclusion set',
      SharedPlatform::LINTING_DEPENDENCIES,
      :development,
      :staging,
      :test,
      :production
  end
end
