bash 'publickey' do
  user 'root'
  code <<-EOH
  rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch
  EOH
end

cookbook_file '/etc/yum.repos.d/elastic.repo' do
	source 'elastic.repo'
	mode 0644
	owner 'root'
	group 'wheel'
end	

yum_package 'filebeat' do
  action :install
end

bash 'filebeat start' do
  user 'root'
  code <<-EOH
  sudo chkconfig --add filebeat
  EOH
end
