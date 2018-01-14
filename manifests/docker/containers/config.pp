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

    #$docker_image = "$gpu['miner']['repo']/$gpu['miner']['image']:$gpu['miner']['tag']"
    $docker_image = $gpu['miner']['tag']

    #$docker_image = "${gpu['miner']['repo']}/${gpu['miner']['image']}"
    #$docker_image = $miner[repo]

    notify { "gpu-${gpu['id']}" :
      message => $docker_image,
    }
  }


}
