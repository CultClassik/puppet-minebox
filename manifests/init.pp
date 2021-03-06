# minebox
#
# Configures a Linux (Ubuntu only for now) system as a crypto currency miner.
#
# @summary A short summary of the purpose of this class
#
# @example
#   include minebox

# make sure we require the puppet-monitoring module
# can't find it on the forge, adding it to the control repo Puppetfile for now to pull from github
#require https://github.com/onpuppet/puppet-monitoring.git

class minebox(
  String $amd_driver_url,
  String $base_path,
  String $storage_path,
  String $miner_user,
  String $miner_group,
  Array $miner_user_groups,
  String $miner_user_pwd,
  String $miner_user_ssh_key,
  Hash $accounts,
  Hash $nv_conf,
  Hash $amd_conf,
  Boolean $cpu_mining,
  Array $packages_base,
  Array $packages_xorg,
  Array $folders,
  Hash $miners,
  Hash $tools,
  Hash $monitor,
  String $grub_options,
){

  include minebox::cleanup
  include minebox::users::base
  include minebox::install
  include minebox::config
  include minebox::tools::base

  Class['::minebox::users::base']
  -> Class['::minebox::install']
  -> Class['::minebox::config']
  -> Class['::minebox::tools::base']

}
