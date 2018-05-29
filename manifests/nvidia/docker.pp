# minebox::nvidia::docker
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include minebox::nvidia::docker
class minebox::nvidia::docker (
  Hash $nv_conf,
  Boolean $remove_old = false,
){
  require docker

  ###########################
  # Remove Nvidia Docker 1.x plugin
  if $remove_old == true {
    exec { ' Remove old Nvidia Docker binaries' :
      refreshonly => true,
      command     => '/usr/bin/docker volume ls -q -f driver=nvidia-docker | /usr/bin/xargs -r -I{} -n1 /usr/bin/docker ps -q -a -f volume={} | /usr/bin/xargs -r /usr/bin/docker rm -f /usr/bin/apt-get purge nvidia-docker',
      before      => Package[$nv_conf['docker_pkg']],
    }
  }
  ###########################

  ##### Adding the repo this way is not working for puppet :(
  # Install Nvidia Docker 2.x plugin
  #apt::source { 'nvidia-docker' :
  #  location     => 'https://nvidia.github.io/nvidia-docker/ubuntu16.04/amd64/nvidia-docker.list',
    #architecture => 'amd64',
    #release      => 'xenial',
    #repos        => 'main',
  #  key          => {
  #    'id'     => 'C95B321B61E88C1809C4F759DDCAE044F796ECB0',
  #    'source' => 'https://nvidia.github.io/nvidia-docker/gpgkey',
  #  },
  #  include      => {
  #    'deb' => true,
  #  },
  #}

##### These are the repos added, not the docker.list one...come back and update this later
#deb https://nvidia.github.io/libnvidia-container/ubuntu16.04/amd64 /
#deb https://nvidia.github.io/nvidia-container-runtime/ubuntu16.04/amd64 /
#deb https://nvidia.github.io/nvidia-docker/ubuntu16.04/amd64 /

  # Hokey way of adding the repo
  file { '/etc/apt/sources.list.d/nvidia-docker.list' :
    ensure => file,
  }
  exec { 'Add Nvidia Repo' :
    command     => '/usr/bin/curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | /usr/bin/apt-key add - && /usr/bin/curl -s -L https://nvidia.github.io/nvidia-docker/ubuntu16.04/amd64/nvidia-docker.list | /usr/bin/tee /etc/apt/sources.list.d/nvidia-docker.list && /usr/bin/apt-get update',
    refreshonly => true,
    subscribe   => File['/etc/apt/sources.list.d/nvidia-docker.list'],
  }
  -> package { $nv_conf['docker_pkg'] :
    ensure => present,
  }

  # Kill Docker if Nvidia Plugin was just installed
  exec { 'Reload Docker daemon' :
    command     => '/usr/bin/pkill -SIGHUP dockerd',
    refreshonly => true,
    subscribe   => Package[$nv_conf['docker_pkg']],
  }

  -> if $nv_conf['use_docker'] == true {
    class { 'minebox::docker::containers::config' :
      gpu_type => 'nvidia',
      gpus     => lookup('minebox::nv_conf.gpus', {merge => 'hash'}),
    }
  }

}
