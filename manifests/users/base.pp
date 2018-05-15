# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include minebox::users::base
class minebox::users::base {
  include minebox::users::user
  include minebox::users::links
  include minebox::users::screen

  Class['::minebox::users::user']
  -> Class['::minebox::users::links']
  -> Class['::minebox::users::screen']

}
