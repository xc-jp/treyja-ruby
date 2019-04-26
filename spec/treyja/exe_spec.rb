require "treyja/exe"

RSpec.describe Treyja::Exe do
  it "shows help" do
    expect {
      Treyja::Exe.new([]).run
    }.to output(/Usage: treyja/).to_stdout
  end

  describe "json" do
    it "outputs tensors in json format" do
      mnist = fixture_path.join("mnist-2.pb")
      expect {
        Treyja::Exe.new(["json", mnist.to_s]).run
      }.to output(/{"tensors":/).to_stdout
    end
  end

  describe "csv" do
    it "outputs tensors in csv format" do
      mnist = fixture_path.join("mnist-2.pb")
      expect {
        Treyja::Exe.new(["csv", mnist.to_s]).run
      }.to output(/0-0_0_0_0,0-0_0_0_1,0-0_0_0_2,/).to_stdout
    end
  end

  describe "dump" do
    it "dumps tensors objects" do
      mnist = fixture_path.join("mnist-2.pb")
      expect {
        Treyja::Exe.new(["dump", mnist.to_s]).run
      }.to output(/<Tensors::TensorsProto: /).to_stdout
    end
  end
end
