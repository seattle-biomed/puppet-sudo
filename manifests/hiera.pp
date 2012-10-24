# = Class: sudo::hiera
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
# include sudo::hiera
#
class sudo::hiera($sudoers) {

  include sudo

  create_resources(sudo::conf, $sudoers)
  
}
