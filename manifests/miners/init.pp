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

  $files.each |String $title, String $name| {
    file { "${files_path}/${name}" :
      ensure => directory,
      owner  => $miner_user,
      group  => $miner_group,
    }

    archive { "${files_path}/${name}" :
      ensure       => present,
      cleanup      => true,
      extract      => true,
      extract_path => "${base_path}",
      source       => "${storage_path}/minebox/$name}",
    }
  }

 # onedrive linux claymore 10.2
 # "https://onedrive.live.com/download?cid=0439AD70307A0AB4&resid=439AD70307A0AB4%2115937&authkey=AEndRVqUqVLFlYM"

 # ethminer
 # https://github.com/ethereum-mining/ethminer/releases/download/v0.12.0/ethminer-0.12.0-Linux.tar.gz


}
