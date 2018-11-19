{
  coderay = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15vav4bhcc2x3jmi3izb11l4d9f3xv8hp2fszb7iqmpsccv1pz4y";
      type = "gem";
    };
    version = "1.1.2";
  };
  google-protobuf = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "134d3ini9ymdwxpz445m28ss9x0m6vcpijcdkzvgk4n538wdmppf";
      type = "gem";
    };
    version = "3.6.1";
  };
  method_source = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pviwzvdqd90gn6y7illcdd9adapw8fczml933p5vl739dkvl3lq";
      type = "gem";
    };
    version = "0.9.2";
  };
  pry = {
    dependencies = ["coderay" "method_source"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1417109nmp7sp8blbdhjx3ckkygm94x1fsfdqn3n7s6dgmc5c35y";
      type = "gem";
    };
    version = "0.12.0";
  };
}
