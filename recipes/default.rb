#
# Cookbook Name:: cloudfoundry-dea
# Recipe:: default
#
# Copyright 2012-2013, ZephirWorks
# Copyright 2012, Trotter Cashion
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

node.default['cloudfoundry_dea']['pid_file'] = File.join(node['cloudfoundry']['pid_dir'], "dea.pid")
node.default['cloudfoundry_dea']['log_file'] = File.join(node['cloudfoundry']['log_dir'], "dea.log")

%w{lsof psmisc librmagick-ruby}.each do |pkg|
  package pkg
end

cloudfoundry_source "dea" do
  path          node['cloudfoundry_dea']['vcap']['install_path']
  repository    node['cloudfoundry_dea']['vcap']['repo']
  reference     node['cloudfoundry_dea']['vcap']['reference']
end

directory node['cloudfoundry_dea']['base_dir'] do
  recursive true
  owner node['cloudfoundry']['user']
  mode  '0755'
end

cloudfoundry_component "dea" do
  install_path  node['cloudfoundry_dea']['vcap']['install_path']
  pid_file      node['cloudfoundry_dea']['pid_file']
  log_file      node['cloudfoundry_dea']['log_file']
  action        [:create, :enable]
  subscribes    :restart, "cloudfoundry_source[dea]"
end
