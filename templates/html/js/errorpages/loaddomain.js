function loadDomain() {
  let proto = location.protocol;
  let port = location.port || 80;
  let url = location.hostname;
  let base = url.pathname.split('/')[1];
  if (proto == 'https:') {
    port = location.port || 443;
  }
  var display = document.getElementById('display-domain');
  display.innerHTML = proto + '//' + url + ':' + port + base;
}
