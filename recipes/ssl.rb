include_recipe "apache2::mod_ssl"

# SSLキーのインストールとホスト設定
#
# キー保存用ディレクトリの作成
directory "#{node['mj-apache2']['ssl_dir']}" do
    owner "root"
    group "root"
    mode 0755
    action :create
end

# Host設定
#
node['mj-apache2']['ssl_hosts'].each do |host|
    # キーファイルの作成
    key_file_name = "#{host['site_name']}-#{host['ssl_key_name']}"

    %w[ crt key cer ].each do |ext|
        cookbook_file "#{node['mj-apache2']['ssl_dir']}/#{key_file_name}.#{ext}" do
            cookbook    host['ssl_cookbook']
            source      "#{host['site_name']}/#{host['ssl_key_name']}.#{ext}.erb"
            owner       "root"
            group       "root"
            mode        "0644"
        end
    end

    directory "#{host['docroot']}" do
        owner "#{node['apache']['user']}"
        group "#{node['apache']['group']}"
        mode 0775
        recursive true
        action :create
    end

    web_app "#{host['site_name']}-ssl" do
        cookbook            host['cookbook']
        template            host['template'] || "web_app-ssl.conf.erb"
        server_port         host['server_port']
        server_name         host['server_name']
        server_aliases      host['server_aliases']
        docroot             host['docroot']
        directory_index     host['directory_index']
        directory_options   host['directory_options']
        allow_override      host['allow_override']
        key_file_name       key_file_name
    end
end
