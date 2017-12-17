# minebox::miners
#
# Configures a Linux (Ubuntu only for now) system as a crypto currency miner.
#
# @summary A short summary of the purpose of this class
#
# @example
#   include minebox::miners
class minebox::miners {
  $files_path = "${minebox::base_path}/files"

  $minebox::miner_bins.each |Hash $program| {
    file { "${files_path}/${title}" :
      ensure => directory,
      owner  => $minebox::miner_user,
      group  => $minebox::miner_group,
    }

    #$minebox::miner_bins.each |String $title, String $name| {
    #file { "${files_path}/${title}" :
    #  ensure => directory,
    #  owner  => $minebox::miner_user,
    #  group  => $minebox::miner_group,
    #}

### make sure that tar is changing the parent folder when unarchiving
    archive { "${files_path}/${title}" :
      ensure       => present,
      cleanup      => true,
      extract      => true,
      extract_path => "${minebox::base_path}",
      source       => "${storage_path}/minebox/$name}",
    }
  }

}
