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

  $gpus.each |$gpu| {
    $image_name = regsubst($gpu['d_image'], '(-)', 'G')
    $docker_image = "${gpu['d_repo']}/${gpu['d_image']}"
    class { "::minebox::docker::containers::${image_name}" :
      docker_image => $docker_image,
      image_tag    => $gpu['d_tag'],
    }
  }

}
