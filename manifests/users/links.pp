# minebox::users::links
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include minebox::users::links
class minebox::users::links {

  # Prob need to put some params up in the init class for the module
  #file { "/home/${minebox::miner_user}/dualmine" :
  #  ensure => link,
  #  target => "${minebox::base_path}/claymore/start.sh",
  #}

}
