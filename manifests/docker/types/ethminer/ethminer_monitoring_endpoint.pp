# minebox::docker::types::ethminer_monitoring_endpoint
#
# Provides an endpoint for use by a monitoring system
#
# @summary Declare this type in a class as an exported resource so our Puppet managed monitoring system can collect and use it
#
# @example
#   minebox::docker::types::ethminer_monitoring_endpoint { 'namevar': }
define minebox::docker::types::ethminer_monitoring_endpoint(
  String $worker_name = $title,
  Integer $monitoring_port = 3333,
) {
  $worker_endpoint = {
    'worker_name'     => $worker_name,
    'monitoring_port' => $monitoring_port,
  }
}
