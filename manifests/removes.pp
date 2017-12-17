# removes
#
# Removes items that were implemented then changed or removed in this module
#
# @summary A short summary of the purpose of this class
#   
#
# @exam
#   include minebox::removes

class minebox::removes(
  String $miner_user = 'miner',
  Array $rclocal = ['X :0 &', 'sleep 5', 'export DISPLAY=:0', 'sleep 3', 'exit 0'],
  Array $files_rm = ['/home/miner/ocnv.sh', '/home/miner/nv-conf.sh', '/home/miner/nvoc_test.sh', '/home/miner/set_oc.sh'],
  Array $docker_img = ['cultclassik/nv-ethminer', 'cultclassik/nvm-claymore'],
)
{
# these need to be in order and they are not, need to switch to using a template most likely
  $rclocal.each |$rclocal_line| {
    file_line { "line_${rclocal_line}" :
      ensure => absent,
      path   => '/etc/rc.local',
      line   => $rclocal_line,
    }
  }

  # Remove installer stuff
  file { "/home/${user_name}/ethminer-0.12.0rc3-Linux.tar.gz" :
    ensure  => absent,
  }

  file { $files_rm :
    ensure => absent,
  }

  $docker_img.each |$img| {
    docker::image { $img :
      ensure => absent,
    }
  }

  docker::run { 'xmr-cpu' :
    ensure => absent,
    image  => 'servethehome/monero_moneropool',
  }

  file { "/home/${user_name}/oc-scripts" :
    ensure => absent,
  }

  file { "/home/${user_name}/m-scripts" :
    ensure => absent,
  }
}
