{ stdenv
, fetchFromGitHub
, ffmpeg
, libjpeg_turbo
, gtk3
, alsaLib
, speex
, libusbmuxd
, libappindicator-gtk3
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "droidcam";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "aramg";
    repo = "droidcam";
    rev = "v${version}";
    sha256 = "tIb7wqzAjSHoT9169NiUO+z6w5DrJVYvkQ3OxDqI1DA=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    ffmpeg
    libjpeg_turbo
    gtk3
    alsaLib
    speex
    libusbmuxd
    libappindicator-gtk3
  ];

  postPatch = ''
    substituteInPlace linux/src/droidcam.c --replace "/opt/droidcam-icon.png" "$out/share/icons/hicolor/droidcam.png"
  '';

  preBuild = ''
    cd linux
    makeFlagsArray+=("JPEG=$(pkg-config --libs --cflags libturbojpeg)")
  '';

  installPhase = ''
    runHook preInstall

    install -Dt $out/bin droidcam droidcam-cli
    install -D icon2.png $out/share/icons/hicolor/droidcam.png

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Linux client for DroidCam app";
    homepage = "https://github.com/aramg/droidcam";
    license = licenses.gpl2;
    maintainers = with maintainers; [ jtojnar suhr ];
    platforms = platforms.linux;
  };
}
