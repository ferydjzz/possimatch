require "possimatch/version"
require "possimatch/helpers/configuration"

module Possimatch

  # for reading config file in initializer
  extend Configuration
  define_setting :possible_matches, 3
  define_setting :stop_after_match, false

end