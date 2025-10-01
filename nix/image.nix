{ misskey, dockerTools, lib, ... }:

dockerTools.streamLayeredImage {
  name = "misskey";

  uid = 991;
  gid = 991;
  uname = "misskey";
  gname = "misskey";

  config = {
    Cmd = ["${lib.getExe misskey}" "/config.yml"];
    Healthcheck = {
      Test = ["${misskey}/bin/misskey-healthcheck" "/config.yml"];
    };
  };
}
