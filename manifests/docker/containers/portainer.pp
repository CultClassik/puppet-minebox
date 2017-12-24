# minebox::docker::containers::portainer
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include minebox::docker::containers::portainer
class minebox::docker::containers::portainer {

  require docker

  docker::run { 'portainer' :
    ensure                   => present,
    image                    => 'portainer/portainer',
    volumes                  => [
      '/etc/localtime:/etc/localtime:ro',
      '/var/run/docker.sock:/var/run/docker.sock:ro',
    ],
    dns                      => ['8.8.8.8', '8.8.4.4'],
    ports                    => ['9000'],
    remove_container_on_stop => true,
    remove_volume_on_stop    => true,
    pull_on_start            => true,
  }

}

