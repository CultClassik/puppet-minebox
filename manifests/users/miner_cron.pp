# miner_cron
#
# Configures cron jobs for user "miner"
#
# @summary A short summary of the purpose of this class
#   This class is no longer used but left in place for reference.
#
# @exam
#   include minebox::users::miner_cron
class minebox::users::miner_cron
{
  # Create miner cron jobs
  cron { 'miner' :
    ensure  => absent,
    command => 'sleep 60 && /usr/bin/screen -d -m',
    user    => 'miner',
    special => 'reboot',
  }

  cron { 'nvoc' :
    ensure  => present,
    command => 'sleep 120 && bash /home/miner/set_oc.sh >/dev/null 2>&1',
    user    => 'root',
    special => 'reboot',
  }
}
