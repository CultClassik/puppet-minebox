# minebox::miners::install
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include minebox::miners::install
class minebox::miners::install (
  String $files_path,
) {

  require archive

  $minebox::downloads.each |String $title, Hash $archive| {
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
      extract_command => "tar -xvf %s -C ${files_path}/${title} –stripcomponents 1",
      source          => $archive['source'],
      user            => $minebox::miner_user,
      group           => $minebox::miner_group,
      creates         => "${files_path}/${title}/ethdcrminer64"
    }
  }

}
