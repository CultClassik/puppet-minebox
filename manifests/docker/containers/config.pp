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

  $gpus.each |Hash $gpu| {
    $image_name = regsubst($gpu['d_image'], '(-)', '_', 'G')

    $docker_image = "${gpu['d_repo']}/${gpu['d_image']}"

    minebox::docker::containers::ethminer_nv { "docker container ${image_name} ${gpu['id']}" :
      gpu          => $gpu,
      docker_image => $docker_image,
      image_tag    => $gpu['d_tag'],
    }
  }

}