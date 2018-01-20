# minebox::tools::miners
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include minebox::tools::miners
class minebox::tools::miners (
  String $files_path,
) {

  $miners = $minebox::miners:hybrid

  if $minebox::nv_conf::enable == true {
    $miners = deep_merge($miners, $minebox::miners:nv)
  }

  if $minebox::amd_conf::enable == true {
    $miners = deep_merge($miners, $minebox::miners:amd)
  }

  $miners.each |String $title, Hash $archive| {
    file { "${files_path}/${title}" :
      ensure => directory,
      owner  => $minebox::miner_user,
      group  => $minebox::miner_group,
      mode   => '0774',
    }

    ### make sure that tar is changing the parent folder when unarchiving
    archive { "${files_path}/${archive['file']}" :
      ensure          => present,
      cleanup         => true,
      extract         => true,
      extract_path    => "${files_path}/${title}",
      extract_command => "tar -xvf %s -C ${files_path}/${title} --strip-components 1",
      source          => $archive['source'],
      user            => $minebox::miner_user,
      group           => $minebox::miner_group,
      creates         => "${files_path}/${title}/${archive['creates']}",
    }
  }

}
