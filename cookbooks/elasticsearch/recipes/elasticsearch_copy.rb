cookbook_file '/etc/yum.repos.d/elasticsearch.repo' do
    source 'elasticsearch.repo'
    mode 0644
    owner 'root'
    group 'wheel'
end
