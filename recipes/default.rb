#
# Cookbook:: apache
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.
package 'apache2'

file '/var/www/html/index.html' do
  content '
  <h2>This is: #{node["name"]}</h2><h1>Hello 4nd Version</h1>
  <div id="main">
        <h2>Devops - Docker (Nginx)</h2><hr>
        <h3>Cuurent Time</h3>
        <p id="timeNow"></p>
    </div>
</body>
<script>
    function startTime() {
    var today = new Date();
    var h = today.getHours();
    var m = today.getMinutes();
    var s = today.getSeconds();
    m = checkTime(m);
    s = checkTime(s);
    document.getElementById("timeNow").innerHTML =
    h + ":" + m + ":" + s;
    var t = setTimeout(startTime, 500);
    }
    function checkTime(i) {
    if (i < 10) {i = "0" + i};
    return i;
    }
</script>
  '
end

service 'apache2' do
  action [ :enable, :start ]
end
