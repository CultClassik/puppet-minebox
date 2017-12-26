# minebox::docker::containers::miners::ethminer_nv
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include minebox::docker::containers::miners::ethminer_nv
class minebox::docker::containers::miners::ethminer_nv (
  Hash $gpu,
  Integer $monitoring_port = 3333,
){

  # Generate a worker name, i.e. "miner02-3"
  $gpu['worker'] = "${trusted['hostname']}-${gpu['id']}"

  minebox::docker::types::ethminer_miner_nv { $gpu['worker'] :
    gpu => $gpu,
  }

  @@minebox::docker::types::ethminer_monitoring_endpoint { $gpu['worker'] :
    monitoring_port => $monitoring_port,
  }
}
