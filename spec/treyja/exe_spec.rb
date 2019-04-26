require "treyja/exe"

RSpec.describe Treyja::Exe do
  it "shows help" do
    expect {
      Treyja::Exe.run
    }.to output(/Usage: treyja/).to_stdout
  end
end
