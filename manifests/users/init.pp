# minebox::users
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include minebox::users
class minebox::users {
  contain minebox::users::install
  contain minebox::users::links

  Class['::minebox::users::install']
  -> Class['::minebox::users::links']

}
