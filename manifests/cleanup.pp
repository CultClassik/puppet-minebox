# minebox::cleanup
#
# A description of what this class does
#
# @summary Used to get rid of old stuff, duh.
#
# @example
#   include minebox::cleanup
class minebox::cleanup {
  
  file_line {'old_nvoc' :
    ensure => absent,
    path => '/etc/rc.local',
    line => '/bin/bash /minebox/scripts/nvoc.sh >/dev/null 2>&1',
  }

}
