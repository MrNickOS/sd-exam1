#bash 'filebeat on boot' do
#  user 'root'
#  code <<-EOH
#  sudo chkconfig --add filebeat
#  EOH
#end
cookbook_file '/etc/yum.repos.d/filebeat.yml' do
	source 'filebeat.yml'
	mode 0644
	owner 'root'
	group 'wheel'
end	

bash 'filebeat start' do
  user 'root'
  code <<-EOH
  systemctl daemon-reload
  systemctl start filebeat
  systemctl enable filebeat
  systemctl restart network
  EOH
end
