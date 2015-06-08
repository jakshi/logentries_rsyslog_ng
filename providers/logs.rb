#
# Cookbook Name:: logentries_rsyslog_ng
# Provider:: default
#
# Author: Kostiantyn Lysenko gshaud@gmail.com
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

def whyrun_supported?
  true
end

use_inline_resources

action :add do
  account_key = new_resource.logentries_account_key
  host_key = Logentries.get_host_key(account_key,new_resource.logentries_logset)
  log_token = Logentries.add_log(account_key,host_key,new_resource.logentries_name)

  # define rsyslog service
  service 'rsyslog' do
    supports :status => true, :start => true, :stop => true, :restart => true, :reload => true
    action :nothing
  end

  # Create log file if it's not exist
  file new_resource.log_filename do
    action :touch
    not_if { ::File.exists?(new_resource.log_filename) }
  end
  
  # Add imfile module

  template '/etc/rsyslog.d/01-module-imfile.conf' do
    cookbook new_resource.cookbook
    source new_resource.imfile_module_source
    only_if { new_resource.imfile_module_source }
  end
  
  template new_resource.rsyslog_conf do
    cookbook new_resource.cookbook
    source new_resource.logentries_source
    variables({
                :log_filename => new_resource.log_filename,
                :rsyslog_tag => new_resource.rsyslog_tag,
                :state_file => "#{new_resource.logentries_name}_state",
                :syslog_facility => new_resource.syslog_facility,
                :logentries_token => log_token,
                :node_identity => new_resource.node_identity,
                :rsyslog_selector => new_resource.rsyslog_selector                
              })
      notifies :restart, 'service[rsyslog]', :delayed
  end

end

action :remove do
  Logentries.remove_log if logentries_log_exist?
  
  rsyslog_remove_log
end

protected

def rsyslog_remove_log
end
