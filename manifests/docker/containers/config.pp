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

  ###testing merge
  $t_defaults = lookup('minebo::miner_defaults.nv.eth')
  $t_gpu = lookup('minebox::nv_conf::gpus.0')
  $gpu_conf = deep_merge($t_defaults, $t_gpu)
  #$gpu_conf = deep_merge($minebox::miner_defaults::nv::eth, $minebox::nv_conf::gpus['0'])
  $worker = $minebox::nv_conf::gpus['0']
  $command = regsubst($gpu_conf['command'], 'WORKER_ID', $worker)
  notify { "${command}" : }
  ###

  $gpus.each |Hash $gpu| {
    $image_name = regsubst($gpu['d_image'], '(-)', '_', 'G')

    $docker_image = "${gpu['d_repo']}/${gpu['d_image']}"

    if $image_name == 'ethminer_nv' {
      minebox::docker::containers::ethminer_nv { "docker container ${image_name} ${gpu['id']}" :
        gpu          => $gpu,
        docker_image => $docker_image,
        image_tag    => $gpu['d_tag'],
      }
    }
    # this is current for nvidia cards with claymore, need to
    # transition to using claymore_ethash
    elsif $image_name == 'claymore_nv' {
      minebox::docker::types::claymore::miner_ethash { "docker container ${image_name} ${gpu['id']}" :
        gpu          => $gpu,
        docker_image => $docker_image,
        image_tag    => $gpu['d_tag'],
      }
    }
    elsif $image_name == 'claymore_eth' {
      minebox::docker::containers::claymore_amd { "docker container ${image_name} ${gpu['id']}" :
        gpu          => $gpu,
        docker_image => $docker_image,
        image_tag    => $gpu['d_tag'],
      }
    }
    elsif $image_name == 'equihash_ewbf_nv' {
      minebox::docker::types::ewbf::miner { "docker container ${image_name} ${gpu['id']}" :
        gpu          => $gpu,
        docker_image => $docker_image,
        image_tag    => $gpu['d_tag'],
      }
    }
  }

}
