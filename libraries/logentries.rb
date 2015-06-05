#
# Cookbook Name:: logentries_rsyslog_ng
# Library:: logentries
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

require 'json'

module Logentries
  def self.get_response(url)
    uri = URI(url)
    response = Net::HTTP.get_response(uri)

    response
  end

  def self.get_host_key(account_key, logentries_logset)
    url = 'http://api.logentries.com/' + account_key + '/hosts/'

    response = get_response(url)
    logsets = JSON.parse(response.body)
    
    hostkey = ''
    
    logsets['list'].each do |logset|
      hostkey = logset['key'] if logset['name'] == logentries_logset
    end

    hostkey
  end

  def self.get_logs(account_key, host_key)
    url = 'http://api.logentries.com/' + account_key + '/hosts/' + host_key + '/'
    response = get_response(url)

    logs = JSON.parse(response.body)

    logs['list']
  end

  def self.log_exist?(account_key, host_key, log_name)
    logs = get_logs(account_key, host_key)

    log_exist = false
    
    logs.each do |log|
      log_exist = true if log['name'] == log_name
    end

    log_exist
  end

  def self.add_log
    
  end

  def self.remove_log
  end

end
