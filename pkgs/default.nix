final: prev: {
  pengu = prev.callPackage ./pengu {};

  phpbb = prev.callPackage ./phpbb {};

  selfoss = prev.callPackage ./selfoss {};

  inherit (prev.recurseIntoAttrs (prev.callPackage ./sublime4/packages.nix { }))
    sublime4-dev;

  droidcam = prev.callPackage ./droidcam {};

  sunflower = prev.callPackage ./sunflower {};

  v4l2loopback-dc = prev.callPackage ./v4l2loopback-dc {
    inherit (prev.linuxPackages) kernel;
  };

  vikunja-api = prev.callPackage ./vikunja/vikunja-api {};

  vikunja-frontend = prev.callPackage ./vikunja/vikunja-frontend {};

  wrcq = prev.callPackage ./wrcq {};

  inherit (prev.callPackages ./utils {})
    deploy
    git-part-pick
    git-auto-fixup
    git-auto-squash
    nix-explore-closure-size
    update
    sman;
}
