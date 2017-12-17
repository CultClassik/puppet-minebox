# cryptomine
#
# Configures a Linux (Ubuntu only for now) system as a crypto currency miner.
#
# @summary A short summary of the purpose of this class
#
# @example
#   include cryptomine

class minebox(
  Boolean $use_docker = true,
  String $cpu_minig = true,
  String $nvdocker_pkg_name = 'nvidia-docker2',
  String $facts_path = '/etc/facter/facts.d',
  String $storage_path = '/sw',
  String $base_path = '/minebox',
  String $miner_user = 'chris',
  String $miner_group = 'miners',
  String $miner_user_pwd,
  String $miner_user_ssh_key,
  Array $miner_user_groups = [
    'adm',
    'video',
    'docker'
    ],
  String $nvidia_driver = 'nvidia-384',
  String $amd_driver = 'amdgpu-pro-17.40-483984',
  Boolean $use_rocm = true,
  String $gpu_type = 'nvidia', # nvidia or amd, was = lookup('minebox::gpu_type')
  Array $folders = [
    'drivers',
    'scripts',
    'files',
    ],
  Array $packages_base = [
    "linux-headers-%{lookup('kernelrelease')}",
    'libcurl3',
    'build-essential',
    'dkms',
    'git',
    'screen',
    'vim',
    'nmap',
    'ncdu',
    'busybox',
    'inxi',
    'links',
    'unzip',
    'openssh-server',
    'htop',
    ],
  Array $packages_xorg = [
    'xserver-xorg',
    'xserver-xorg-core',
    'xserver-xorg-input-evdev',
    'xserver-xorg-video-dummy',
    'x11-xserver-utils',
    'xdm',
    'gtk2.0',
    ],
  Hash $miner_bins = {
    'claymore' => {
      'version' => '10.2',
      'source'  => 'https://onedrive.live.com/download?cid=0439AD70307A0AB4&resid=439AD70307A0AB4%2115937&authkey=AEndRVqUqVLFlYM',
      'file'    => 'claymore.tar.gz'
      },
    'ethminer' => {
      'version' => '0.12.0',
      'source'  => 'https://github.com/ethereum-mining/ethminer/releases/download/v0.12.0/ethminer-0.12.0-Linux.tar.gz',
      'file'    => 'ethminer.tar.gz',
      }
    }
)
{
  # trying to avoid running x - amd doesn't need it and nvidia should be able to use nvidia-persistenced instead
  #contain minebox::xorg::headless
  # require stdlib, reboot, cron
  require apt
  
  contain minebox::install
  contain minebox::config

  Class['::minebox::install']
  -> Class['::minebox::config']

  file { $storage_path :
    ensure => directory
  }
  # move this to a profile manifest
  -> file_line { 'Mount Storage Share' :
    path => '/etc/fstab',
    line => 'nastee.diehlabs.lan:/software   /sw   nfs     defaults        0       0',
  }

  exec { 'Refresh mounts' :
    command     => '/bin/mount',
    subscribe   => File_line['Mount Storage Share'],
    refreshonly => true, 
  }
  
  # Create .screenrc script - this is already in minebox::users::base - compare and remove this one
  file { "/home/${user_name}/.screenrc" :
    ensure  => file,
    content => epp('cryptomine/screenrc.epp', { 'gpu_cfg' => lookup('minebox::docker::containers::ethminer_nv::gpus') }),
    owner   => $miner_user,
    group   => $miner_group,
    mode    => '0774',
  }

 # Update bashrc
  $bashrc_files = ["/home/${user_name}/.bashrc",'/etc/skel/.bashrc']
  $bashrc_files.each |String $brc| {
    file { $brc :
      ensure => file,
    }
    ->file_line { $brc :
      path   => $brc,
      line   => 'export DISPLAY=:0',
      notify => Exec['Update xdm'],
    }
  }
 
  

#  package { 'adafruit-ampy' :
#    ensure   => 'latest',
#    provider => 'yuavpip',
#    require  => Class['pip'],
#  }

#  python::pip { 'adafruit-ampy' :
#    pkgname       => 'cx_Oracle',
#    ensure        => 'latest',
#  }
}
