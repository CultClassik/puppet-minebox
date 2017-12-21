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
    class { "::minebox::docker::containers::${gpu['d_image']}" :
      docker_image => $gpu['d_image_name'],
      image_tag    => $gpu['d_image_tag'],
    }
  }

}
