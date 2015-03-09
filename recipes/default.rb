#
# Cookbook Name:: mj-apache2
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "apache2"


# hostsで定義された内容を web_app にて VirtualHost制御
node['mj-apache2']['hosts'].each do |host|
    directory "#{host['docroot']}" do
        owner "#{node['apache']['user']}"
        group "#{node['apache']['group']}"
        mode 0775
        recursive true
        action :create
    end

    web_app host['site_name'] do
        cookbook            host['cookbook'] || "apache2"
        template            host['template'] || "web_app.conf.erb"
        server_port         host['server_port']
        server_name         host['server_name']
        server_aliases      host['server_aliases']
        docroot             host['docroot']
        directory_index     host['directory_index']
        directory_options   host['directory_options']
        allow_override      host['allow_override']
        rewrite_loglevel    host['rewrite_loglevel']
    end
end

# php.ini の更新をチェックして、Apacheをリロードする
# とりあえず強制リロード
#
service "apache2" do
    action [ :reload ]
end
