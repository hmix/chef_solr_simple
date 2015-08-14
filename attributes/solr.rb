default['solr']['version'] = '5.2.1'
default['solr']['url'] = "http://apache.openmirror.de/lucene/solr/#{node['solr']['version']}/solr-#{node['solr']['version']}.tgz"
default['solr']['dir'] = "/usr/local"
default['solr']['home'] = "/usr/local/solr-#{node['solr']['version']}"
