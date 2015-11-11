RSpec.configure do |config|
  config.color = true
end

def spec_dir
  File.expand_path('../', __FILE__)
end

def result_file(name)
  File.join(spec_dir, 'results', name)
end

def stub_file(name)
  File.join(spec_dir, 'stubs', name)
end
