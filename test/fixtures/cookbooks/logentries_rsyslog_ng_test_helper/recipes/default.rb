#
# Cookbook Name:: logentries_rsyslog_ng_test_helper
# Recipe:: default
#
# Copyright 2015 Kostiantyn Lysenko
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

# Create logentries group
group 'loggroup'

# Create logentries user
user 'loguser'

# Create dull log
logentries_rsyslog_ng_logs '/var/log/testlog' do
  log_owner 'loguser'
  log_group 'loggroup'
  logentries_logset 'DemoSet'
  logentries_name 'testlog'
  logentries_account_key node['logentries']['token']
  rsyslog_ruleset 'testlog'
  rsyslog_conf '/etc/rsyslog.d/20-testlog.conf'
  rsyslog_tag 'testlog'
  rsyslog_selector ":syslogtag, isequal, \"testlog:\""
end

execute 'block request to logentries' do
  command 'iptables -A OUTPUT -p tcp --dport 80 -j DROP'
end

# imitate second run with creating dull log
logentries_rsyslog_ng_logs '/var/log/testlog' do
  log_owner 'loguser'
  log_group 'loggroup'
  logentries_logset 'DemoSet'
  logentries_name 'testlog'
  logentries_account_key node['logentries']['token']
  rsyslog_ruleset 'testlog'
  rsyslog_conf '/etc/rsyslog.d/20-testlog.conf'
  rsyslog_tag 'testlog'
  rsyslog_selector ":syslogtag, isequal, \"testlog:\""
end

execute 'unblock request to logentries' do
  command 'iptables -D OUTPUT -p tcp --dport 80 -j DROP'
end
