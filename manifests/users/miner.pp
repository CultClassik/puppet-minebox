# miner
#
# Configures user "miner"
#
# @summary A short summary of the purpose of this class
#
# @exam
#   include minebox::users::miner

class minebox::users::miner
(
  String $miner_user='miner',
  String $uid='1050',
  Array $groups = ['adm', 'sudo', 'video', 'docker'],
  String $password='$1$eE96Tapg$VVdhbw9Zq/MoEBibrJVO.0',
  String $ssh_key='AAAAB3NzaC1yc2EAAAADAQABAAABAQDm8xmzFlG70jBZo78S0b6sVikwQpfEI5RPuteAMZIUjukhjzgQ5WLAtcmy05INO1yJIkcsNmkGd8cDskcjvlXg0pBr/ZSXg1316SxW+OuFHrvZIFHXccrYEjOO+DIgr/5HNPfHjEnfBXIWvU5C/2XlzKDc+LxpXWTGQ6kslYiQgu2L5CzJKtGfM5k8wsJoL2beItwCs7rSP5b4owt1KcXrSJgNRQovVEvi9A9yAd4eogY1H4DyaU0osc/P7k3vU5KJpLl21N5MZk0V+ti6o2PtREA8+KorrEtnm+4cARY5y/rpaj3HHBB9HvzXnqMgDFKKn/+TSS+SowZFCu5peZ1r',
  Hash $scripts={
    'miner.sh'   => 'puppet:///modules/cryptomine/miner.sh',
    #'conf-nv.sh' => 'puppet:///modules/cryptomine/conf-nv.sh',
    },
)
{
  # Create .screenrc script
  file { '/home/miner/.screenrc' :
    ensure  => file,
    content => epp('cryptomine/screenrc.epp', { 'gpu_cfg' => lookup('minebox::docker::containers::ethminer_nv::gpus') }),
    owner   => $miner_user,
    group   => $miner_user,
    mode    => '0774',
  }

  # Create core mining scripts
  $scripts.each |$script, $path| {
    file { "/home/${user_name}/${script}" :
      ensure => file,
      owner  => $miner_user,
      group  => $miner_user,
      mode   => '0774',
      source => $path,
    }
  }


}
