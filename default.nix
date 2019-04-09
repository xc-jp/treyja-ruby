{ nixpkgs ? null }:

let
  src = builtins.fetchTarball {
    # nixpkgs-19.03 as of 2019/03/11.
    url = "https://github.com/NixOS/nixpkgs/archive/50876481a0127ad885fcbfd48ab24bbacbc26395.tar.gz";
    sha256 = "063q2jhi9lf6azbhlrn3cygpaa3n65n3d8g7c1s0vvsj8rxv8b80";
  };

  pkgs = if isNull nixpkgs then src else nixpkgs;
in

with (import pkgs {});

let
  # This needs to be ruby-2.5.
  treyjaRuby = ruby_2_5;

  gems = bundlerEnv {
    name = "treyja-env";

    ruby = treyjaRuby;

    # This specifies the directory with the `Gemfile`, `Gemfile.lock`,
    # and `gemset.nix` file.
    #
    # The `../gemset.nix` file can be regenerated with the
    # following command.  This needs to be done whenever the
    # `Gemfile.lock` file changes.
    #
    # $ $(nix-build /some/path/to/nixpkgs -A bundix --no-out-link)/bin/bundix --magic
    gemdir = ./.;
  };

in

stdenv.mkDerivation {
  name = "treyja-bin";
  src = ./.;
  buildInputs = [ gems.wrappedRuby ];
  nativeBuildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir -p $out
    install -D -m755 $src/bin/treyja $out/bin/treyja
    makeWrapper $src/bin/treyja $out/bin/treyja \
      --set BUNDLE_GEMFILE ${gems.confFiles}/Gemfile \
      --set BUNDLE_PATH ${gems}/${treyjaRuby.gemPath} \
      --set BUNDLE_FROZEN 1 \
      --set GEM_HOME ${gems}/${treyjaRuby.gemPath} \
      --set GEM_PATH ${gems}/${treyjaRuby.gemPath} \
      --set PATH "${gems.wrappedRuby}/bin:$PATH"
  '';
}
