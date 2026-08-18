{
  lib,
  stdenv,
  fetchFromGitHub,
  buildNpmPackage,
  nodejs_24,
  pkg-config,
  xcbuild,
  pango,
  giflib,
  jellyfin,
}:

buildNpmPackage (finalAttrs: {
  pname = "jellyfin-web";
  version = "12.0-rc5";

  src =
    assert finalAttrs.version == jellyfin.version;
    fetchFromGitHub {
      owner = "jellyfin";
      repo = "jellyfin-web";
      tag = "v${finalAttrs.version}";
      hash = "sha256-zd+iguPg0pbQtK/4VjYnFiDCXF/5N6ltO8YZ0QMiHCA=";
    };

  nodejs = nodejs_24;

  postPatch = ''
    substituteInPlace webpack.common.js \
      --replace-fail "git describe --always --dirty" "echo ${finalAttrs.src.rev}"
  '';

  npmDepsHash = "sha256-1s9PWqakzZMiZokOqnKfwaj9s7yWm6e/xh4R5OmTNMc=";

  preBuild = ''
    rm -r node_modules/sass-embedded*
  '';

  npmBuildScript = [ "build:production" ];

  nativeBuildInputs = [ pkg-config ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ xcbuild ];

  buildInputs = [ pango ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ giflib ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
    cp -a dist $out/share/jellyfin-web

    runHook postInstall
  '';

  meta = {
    description = "Web Client for Jellyfin";
    homepage = "https://jellyfin.org/";
    license = lib.licenses.gpl2Plus;
  };
})
