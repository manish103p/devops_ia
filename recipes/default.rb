
package 'apache2'

file '/var/www/html/index.html' do
  content "
  <h2>This is: #{node['name']}</h2><h1>Hello 9th Version</h1>
  "
end

service 'apache2' do
  action [ :enable, :start ]
end
