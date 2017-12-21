# minebox::docker::containers::remove
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include minebox::docker::containers::remove
class minebox::docker::containers::remove (
  String $container_name,
) {
  #docker ps -a --no-trunc --filter name=^/m-nv1$
  docker::run { $container_name :
    ensure => absent,
  }
}
