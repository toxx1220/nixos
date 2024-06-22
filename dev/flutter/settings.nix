{ system-info, ... }:

{
  # All this is not helping android studio emulators to work.
  users.groups.plugdev = { 
    members = [ "${system-info.username}" ];
  };
  programs.adb.enable = true;
  users.groups.adbusers = { 
    members = [ "${system-info.username}"];
  };
   users.groups.test = { 
    members = [ "${system-info.username}"];
  };
}