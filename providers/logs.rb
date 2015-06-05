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

  rsyslog_add_log
end

action :remove do
  Logentries.remove_log if logentries_log_exist?
  
  rsyslog_remove_log
end

protected

def rsyslog_add_log
end

def rsyslog_remove_log
end
