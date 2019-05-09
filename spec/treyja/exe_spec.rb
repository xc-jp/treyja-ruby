require "tmpdir"
require "treyja/exe"

RSpec.describe Treyja::Exe do
  describe "help" do
    it "shows help" do
      expect {
        Treyja::Exe.new([]).run
      }.to output(/Usage: treyja/).to_stdout
    end

    it "shows help when `--help` options given" do
      expect {
        Treyja::Exe.new(["--help"]).run
      }.to output(/Usage: treyja/).to_stdout
    end

    it "shows help if command is invalid" do
      expect {
        Treyja::Exe.new(["no-such-command"]).run
      }.to output(/Usage: treyja/).to_stdout
    end
  end

  describe "version" do
    it "shows version" do
      expect {
        Treyja::Exe.new(["--version"]).run
      }.to output("Version: 0.1.3\n").to_stdout
    end
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

  describe "image" do
    it "outputs images" do
      mnist = fixture_path.join("mnist-2.pb")
      Dir.mktmpdir("treyja-ruby") do |dir|
        Treyja::Exe.new(["image", mnist.to_s, "--output", dir]).run
        expect(Dir[File.join(dir, "*.png")].count).to eq 34
      end
    end

    it "outputs normalized images when `--normalize` option given" do
      mnist = fixture_path.join("mnist-2.pb")
      Dir.mktmpdir("treyja-ruby") do |dir|
        Treyja::Exe.new(["image", mnist.to_s, "--output", dir, "--normalize"]).run
        expect(Dir[File.join(dir, "*.png")].count).to eq 34
      end
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
