{ config, pkgs, inputs, system-info, ... }:

{
  users.groups.plugdev = { 
    members = [ "${system-info.username}" ];
  };
}