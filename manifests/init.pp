# minebox
#
# Configures a Linux (Ubuntu only for now) system as a crypto currency miner.
#
# @summary A short summary of the purpose of this class
#
# @example
#   include minebox

class minebox(
  String $gpu_type,
  String $miner_user_pwd,
  String $miner_user_ssh_key,
  String $storage_path,
  Hash $nv_gpus = {},
  Integer $gpu_fan = 0,
  Boolean $use_docker = true,
  Boolean $cpu_mining = true,
  String $nvdocker_pkg_name = 'nvidia-docker2',
  String $facts_path = '/etc/facter/facts.d',
  String $base_path = '/minebox',
  String $miner_user = 'miner',
  String $miner_group = 'miners',
  Array $miner_user_groups = [
    'adm',
    'sudo',
    'video',
    ],
  String $nvidia_driver = 'nvidia-384',
  String $amd_driver = 'amdgpu-pro-17.40-483984',
  Boolean $use_rocm = true,
  Array $folders = [
    'drivers',
    'scripts',
    'files',
    ],
  Array $packages_base = [
    "linux-headers-${facts['kernelrelease']}",
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
  Hash $downloads = {
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
    },
  Hash $accounts = {
    'eth' => '0x96ae82e89ff22b3eff481e2499948c562354cb23',
    'lbc' => 'cultclassik',
    'xmr' => '447vxA7StEu5Ht9p8MiWNmhLo48dYnfwPGUYtxUAArxKD6DkSthnQiVL843NKEC1oGTS6Gmu3XaoK3uBcQ118zXaFPjLdxz',
    'sia' => '9e4337a945bdcbb7e9edfc6889a89202ea4e72d1ea389d8090bf117656e83bcb223626f10681',
  }
  ) {

  # require stdlib, reboot, cron, apt, docker
  require apt

  include minebox::users::base
  contain minebox::install
  contain minebox::config

  Class['::minebox::users::base']
  -> Class['::minebox::install']
  -> Class['::minebox::config']

}
