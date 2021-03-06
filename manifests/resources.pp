# = Class: sudo::resources
#
# Configure sudo using information from hiera to populate parameters.
#
# == Parameters:
#  - sudoers: Hash of sudoer information, intended to be provided by hiera
#
# == Actions:
#  - include sudo class (package installation and config file)
#
# == Authors:
#  - Andrew Leonard <andy.leonard@sbri.org>
#
# == Requires:
#  - sudo
#  - sudo::conf
#
# == Sample Usage:
#
# include sudo::resources
#
class sudo::resources($sudoers) {

  include sudo

  create_resources(sudo::conf, $sudoers)
  
}
