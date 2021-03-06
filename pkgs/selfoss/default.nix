{ stdenv
, fetchurl
, lib
, unzip
}:

stdenv.mkDerivation rec {
  pname = "selfoss";
  version = "2.19-664481d";

  src = fetchurl {
    url = "https://dl.bintray.com/fossar/selfoss/selfoss-${version}.zip";
    sha256 = "gnGpcCBHjQvdL5GJyU7fDDV0eACJtcnySBnhZ2PiThw=";
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
    description = "Multipurpose RSS reader and aggregation web app";
    homepage = "https://selfoss.aditu.de";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ jtojnar ];
    platforms = lib.platforms.all;
  };
}
