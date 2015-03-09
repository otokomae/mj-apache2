# fastcgi設定で利用する mod_actions を有効に
#
apache_module 'actions' do
    enable true
end

# libapache2_mod_fastcgi をインストールするために multiverseを有効に
#
apt_repository 'multiverse' do
  uri          'http://jp.archive.ubuntu.com/ubuntu'
  distribution 'trusty'
  components   ['multiverse']
  deb_src      true
  action :add
end

# mod_fastcgi を有効に
include_recipe "apache2::mod_fastcgi"

# fastcgi稼働用ディレクトリを作成
#
directory "#{node['apache']['dir']}/#{node['mj-apache2']['fcgi_dir']}" do
    owner "root"
    group "root"
    mode 0755
    action :create
end

# php5-fpm と連繋するための設定ファイルを作成し有効化
#
template "#{node['apache']['dir']}/conf-available/php5-fpm.conf" do
    owner 'root'
    group 'root'
    mode '0644'
end

apache_config 'php5-fpm' do
    enable true
end
