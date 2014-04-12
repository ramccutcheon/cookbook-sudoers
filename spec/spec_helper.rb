require 'chefspec'
require 'chefspec/berkshelf'
require 'chefspec/server'

at_exit { ChefSpec::Coverage.report! }

# Helper methods
# From the openstack cookbooks
module Helpers
  # Create an anchored regex to exactly match the entire line
  # (name borrowed from grep --line-regexp)
  #
  # @param [String] str The whole line to match
  # @return [Regexp] The anchored/escaped regular expression
  def line_regexp(str)
    /^#{Regexp.quote(str)}$/
  end
end
