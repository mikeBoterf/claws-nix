{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "claws";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "clawscli";
    repo = "claws";
    rev = "v${version}";
    hash = "sha256-z5QzvmyUpswcUqlDm92WAnjTWWFSDHFWAl1bnFZmGq4=";
  };

  vendorHash = "sha256-Ef/2Xs15E5noUYJk2J9k48g0kfTPB6v+D9uUHdOyya0=";

  subPackages = [ "cmd/claws" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  meta = {
    description = "Terminal UI for AWS resource management";
    homepage = "https://github.com/clawscli/claws";
    license = lib.licenses.asl20;
    mainProgram = "claws";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
