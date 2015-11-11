require "spec_helper"
require "bosh/workspace/rspec"

Dir['deployments/*.yml'].each do |deployment_file|
  base = File.basename(deployment_file)
  describe base do
    include_examples(
      "behaves as bosh-workspace deployment",
      deployment_file,
      result_file(base),
      stub_file(base)
    )
  end
end
