# minebox::docker::containers::config
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include minebox::docker::containers::config
class minebox::docker::containers::config (
  Array $gpus,
) {

  notify { 'Applying Docker GPU Miner Container Class..' : }

  # merge defaults with gpu specific configs
  #$gpu_defaults = lookup('minebox::miner_defaults.nv.eth')

  $gpus.each |Hash $gpu| {
    # Replace - in image names with _
    $image_name = regsubst($gpu['miner']['image'], '(-)', '_', 'G')

    # generate full image name from repo and image variable values
    $docker_image = "${gpu['d_repo']}/${gpu['d_image']}"

    if $image_name == 'ethminer_nv' {
      minebox::docker::containers::ethminer_nv { "docker container ${image_name} ${gpu['id']}" :
        gpu          => $gpu,
        docker_image => $gpu['miner']['image'],
        image_tag    => $gpu['miner']['tag'],
      }
    }
    # this is current for nvidia cards with claymore, need to
    # transition to using claymore_ethash
    elsif $image_name == 'claymore_nv' {
      minebox::docker::types::claymore::miner_ethash { "docker container ${image_name} ${gpu['id']}" :
        gpu          => $gpu,
        docker_image => $gpu['miner']['image'],
        image_tag    => $gpu['miner']['tag'],
      }
    }
    elsif $image_name == 'claymore_eth' {
      minebox::docker::containers::claymore_amd { "docker container ${image_name} ${gpu['id']}" :
        gpu          => $gpu,
        docker_image => $gpu['miner']['image'],
        image_tag    => $gpu['miner']['tag'],
      }
    }
    elsif $image_name == 'equihash_ewbf_nv' {
      minebox::docker::types::ewbf::miner { "docker container ${image_name} ${gpu['id']}" :
        gpu          => $gpu,
        docker_image => $gpu['miner']['image'],
        image_tag    => $gpu['miner']['tag'],
      }
    }
    elsif $image_name == 'dstm' {
      minebox::docker::types::ewbf::miner { "docker container ${image_name} ${gpu['id']}" :
        gpu          => $gpu,
        docker_image => $gpu['miner']['image'],
        image_tag    => $gpu['miner']['tag'],
      }
    }

  }

}