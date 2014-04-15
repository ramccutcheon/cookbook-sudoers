#
# Cookbook Name:: sudoers
# Recipe:: default
#
# Copyright 2014, Scott Lampert <scott@lampert.org>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'sudo'

# Make sure ssh forwarding gets picked up if its being used.
node.override['authorization']['sudo']['agent_forwarding'] = true

sudoers = SudoersDataBags.new.get(node['sudoers']['databag'])

sudoers.each do |s|
  if s['action'] && s['action'] == 'remove'
    filename = ::File.join('/etc/sudoers.d', s['id'])

    ::Chef::Log.info "[sudoers] INFO: Removing #{filename}"
    if ::File.exists?(filename)
      file filename do
        action :delete
      end
    end
  else
    next if s['zone'] && node['zone'] != s['zone']
    next if s['host'] && node['hostname'] != s['host']

    use_nopasswd = (s['nopasswd'] == 'true')

    ::Chef::Log.info "[sudoers] INFO: Adding sudo for #{s['id']}"
    sudo s['id'] do
      user s['user'] if s['user']
      group s['group'] if s['group']
      runas s['runas'] if s['runas']
      commands [s['commands']].flatten if s['commands']
      host s['host'] if s['host']
      nopasswd use_nopasswd
      defaults [s['defaults']].flatten if s['defaults']
    end
  end
end
