{
  lib,
  fetchFromGitHub,
  dotnetCorePackages,
  buildDotnetModule,
  jellyfin-ffmpeg,
  fontconfig,
  freetype,
  jellyfin-web,
  sqlite,
  jq,
}:

buildDotnetModule (finalAttrs: {
  pname = "jellyfin";
  version = "12.0-rc5";

  src = fetchFromGitHub {
    owner = "jellyfin";
    repo = "jellyfin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-f3hBWguyguId3aEPaTB5gXsIHY51ExZ7CUXFbA5HFzY=";
  };

  nativeBuildInputs = [ jq ];

  propagatedBuildInputs = [ sqlite ];

  projectFile = "Jellyfin.Server/Jellyfin.Server.csproj";
  executables = [ "jellyfin" ];
  nugetDeps = ./nuget-deps.json;
  runtimeDeps = [
    jellyfin-ffmpeg
    fontconfig
    freetype
  ];
  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_10_0;
  runtimeId = "linux-x64";
  dotnetBuildFlags = [ "--no-self-contained" ];

  makeWrapperArgs = [
    "--add-flags"
    "--ffmpeg=${jellyfin-ffmpeg}/bin/ffmpeg"
    "--add-flags"
    "--webdir=${jellyfin-web}/share/jellyfin-web"
  ];

  postFixup = ''
    timestamp="$(TZ=GMT date -d "@$SOURCE_DATE_EPOCH" '+%a, %d %b %Y %X GMT')"

    jq --arg timestamp "$timestamp" \
      '.Endpoints[].ResponseHeaders[] |= if (.Name == "Last-Modified") then .Value = $timestamp else . end' \
      "$out/lib/jellyfin/jellyfin.staticwebassets.endpoints.json" \
      > jellyfin.staticwebassets.endpoints.json.new

    mv jellyfin.staticwebassets.endpoints.json.new \
      "$out/lib/jellyfin/jellyfin.staticwebassets.endpoints.json"
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    output="$($out/bin/jellyfin --help 2>&1 || true)"
    grep -F "Jellyfin.Server 12.0.0.0" <<< "$output"

    runHook postInstallCheck
  '';

  meta = {
    description = "Free Software Media System";
    homepage = "https://jellyfin.org/";
    license = lib.licenses.gpl2Plus;
    mainProgram = "jellyfin";
    platforms = [ "x86_64-linux" ];
  };
})
