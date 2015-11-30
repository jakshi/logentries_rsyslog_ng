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

# Be sure that backports are available
apt_repository 'debian_wheezy_backport' do
  uri        'http://ftp.debian.org/debian'
  components ['wheezy-backports', 'main']
end.run_action(:add)

%w{rsyslog rsyslog-gnutls}.each do |pkg|
  package pkg do
    action :nothing
    default_release 'wheezy-backports'
  end.run_action(:upgrade)
end

::File.open('/var/log/testlog', 'w') {|f| f.write("this is a test log file\n") }

service 'rsyslog' do
  supports :status => true, :start => true, :stop => true, :restart => true, :reload => true
  action :nothing
end

# Create dull log
logentries_rsyslog_ng_logs '/var/log/testlog' do
  logentries_logset 'DemoSet'
  logentries_name 'testlog'
  logentries_account_key node['logentries']['token']
  rsyslog_tls_enable false
  rsyslog_ruleset 'testlog'
  rsyslog_conf '/etc/rsyslog.d/20-testlog.conf'
  rsyslog_tag 'testlog'
  rsyslog_selector ":syslogtag, isequal, \"testlog:\""
end

service 'rsyslog' do
  action :restart
end

file '/var/log/testlog' do
  content IO.read('/var/log/testlog') + "test string 1\n"
end
