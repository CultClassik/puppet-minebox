# minebox::users::screen
#
# Generates a .screenrc file for the miner user and
# runs screen 60 seconds after boot.
#
# @summary A short summary of the purpose of this class
#
# NOTE - hybrid amd/nv not supported by the YET
# NOTE - need to consolidate and/or refactor screenrc templates
# @example
#   include minebox::users::screen
class minebox::users::screen {

  $minebox::nv_conf['gpus'].each |$gpu| {
    notify { "GPU-${gpu['id']}" :
      message => $gpu,
    }
  }

  $cron_screen = 'absent'

}
