# headless
#
# Configures Linux Xorg Server for headless operation
#
# @summary A short summary of the purpose of this class
#
# @exam
#   include minebox::xorg::headless
class minebox::xorg::headless {

  file { '/etc/X11/xdm/Xsetup' :
    ensure => file,
    source => 'puppet:///modules/minebox/Xsetup',
    mode   => '0755',
  }

  file_line { 'xauthority export':
    path => '/etc/profile',
    line => 'export XAUTHORITY=~/.Xauthority',
  }

  file_line { 'xwrapper needs root rights':
    path  => '/etc/X11/Xwrapper.config',
    line  => 'needs_root_rights=yes',
    match => '^needs_root_rights=.*$',
  }

  file_line { 'xwrapper allowed users':
    path  => '/etc/X11/Xwrapper.config',
    line  => 'allowed_users=anybody',
    match => '^allowed_users=.*$',
  }

  file_line { 'xinit_stuff' :
    path => "/home/${minebox::user_name}/.xinitrc",
    line => 'DISPLAY=:0 && xterm -geometry +1+1 -n login',
  }


}
