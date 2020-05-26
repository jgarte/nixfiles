{ stdenv
, fetchurl
, lib
, unzip
}:

stdenv.mkDerivation rec {
  pname = "selfoss";
  version = "2.19-9f41abb";

  src = fetchurl {
    url = "https://dl.bintray.com/fossar/selfoss/selfoss-${version}.zip";
    sha256 = "xQQQkmBnXjKNpGmRtV59M8kwV853x2kdyounu8Geq0A=";
  };

  nativeBuildInputs = [
    unzip
  ];

  installPhase = ''
    runHook preInstall

    # Enable debug mode.
    substituteInPlace src/common.php --replace "\$f3->set('DEBUG', 0);" "\$f3->set('DEBUG', 1);"

    cp -r . $out

    runHook postInstall
  '';

  passthru = {
    updateScript = ./update.sh;
  };

  meta = {
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ jtojnar ];
  };
}