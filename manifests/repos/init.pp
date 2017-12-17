# repos
#
# Configures repos required for module
#
# @summary A short summary of the purpose of this class
#   This class is no longer used but left in place for reference.
#
# @exam
#   include minebox::repos

class minebox::repos(
  String $miner_user = 'miner',
)
{
  # Clone minebox git repo
  vcsrepo { "/home/${user_name}/repo/minebox" :
    ensure   => present,
    provider => git,
    source   => 'https://github.com/CultClassik/minebox.git',
    revision => 'master',
  }

}
