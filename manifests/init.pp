# minebox
#
# Configures a Linux (Ubuntu only for now) system as a crypto currency miner.
#
# @summary A short summary of the purpose of this class
#
# @example
#   include minebox

class minebox(
  String $storage_path = 'undef',
  String $miner_user_pwd = 'undef',
  String $miner_user_ssh_key = 'undef',
  Hash $nv_conf = {
    'enable'     => false,
    'use_docker' => true,
    'gpu_fan'    => 0,
    'driver'     => 'nvidia-384',
    'docker_pkg' => 'nvidia-docker2',
    'gpus'       => [],
  },
  Hash $amd_conf = {
    'enable'     => false,
    'use_docker' => false,
    'gpu_fan'    => 0,
    'driver'     => 'amdgpu-pro-17.50-511655',
  },
  Boolean $cpu_mining = true,
  String $base_path = '/minebox',
  String $miner_user = 'miner',
  String $miner_group = 'miners',
  Array $miner_user_groups = [
    'adm',
    'sudo',
    'video',
    'docker',
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
  Array $folders = [
    'drivers',
    'scripts',
    'files',
    'miners',
    'tools',
    ],
  Hash $miners = {
    'claymore' => {
      'version' => '10.3',
      'source'  => 'https://s3-us-west-1.amazonaws.com/mastermine/minebox/claymore_Ethereum%2BDecred_Siacoin_Lbry_Pascal_gpu_v10.3_+LINUX.tar.gz',
      'file'    => 'claymore.tar.gz',
      'creates' => 'ethdcrminer64',
      },
    'ethminer' => {
      'version' => '0.12.0',
      'source'  => 'https://github.com/ethereum-mining/ethminer/releases/download/v0.12.0/ethminer-0.12.0-Linux.tar.gz',
      'file'    => 'ethminer.tar.gz',
      'creates' => 'ethminer',
      },
    'claymore-equi' => {
      'version' => '12.6',
      'source'  => 'https://s3-us-west-1.amazonaws.com/mastermine/minebox/claymore_ZCash_AMD_GPU_Miner_v12.6_LINUX.tar.gz',
      'file'    => 'claymore-equi.tar.gz',
      'creates' => 'zecminer64',
    },
  },
  Hash $tools = {
    },
  Hash $accounts = {
    'eth' => '0x96ae82e89ff22b3eff481e2499948c562354cb23',
    'lbc' => 'cultclassik',
    'xmr' => '447vxA7StEu5Ht9p8MiWNmhLo48dYnfwPGUYtxUAArxKD6DkSthnQiVL843NKEC1oGTS6Gmu3XaoK3uBcQ118zXaFPjLdxz',
    'sia' => '9e4337a945bdcbb7e9edfc6889a89202ea4e72d1ea389d8090bf117656e83bcb223626f10681',
    'zcl' => 't1R1VkvxFBFsfdU2MaRnJSHvnkVNhuFiydF',
    'zec' => 'your_t_addr_here',
  },
  #move this to the miners hash param
  Hash $claymore = {
    'dcri'     => 8,
    'etha'     => 2,
    'ethi'     => 8,
    'platform' => undef,
  },
  ) {

  include minebox::users::install
  contain minebox::install
  contain minebox::config
  contain minebox::tools::base

  Class['::minebox::users::install']
  -> Class['::minebox::install']
  -> Class['::minebox::config']
  -> Class['::minebox::tools::base']

}
