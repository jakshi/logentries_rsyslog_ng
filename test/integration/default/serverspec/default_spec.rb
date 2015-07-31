require 'spec_helper'

describe 'logentries_rsyslog_ng LWRP' do
  
  it 'creates log file if log file doesn\'t exist' do
    expect(file '/var/log/testlog').to be_file
  end

  it 'can create that log file with specific user/group ownership' do
    expect(file '/var/log/testlog').to be_owned_by 'loguser'
    expect(file '/var/log/testlog').to be_grouped_into 'loggroup'
  end
  
end
