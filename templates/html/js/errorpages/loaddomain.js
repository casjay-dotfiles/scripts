function loadDomain() {
  let proto = location.protocol;
  let port = location.port || 80;
  let url = location.hostname;
  let base = location.pathname.split('/')[1];
  if (proto == 'https:') {
    port = location.port || 443;
  }
  full_url = proto + '//' + url + ':' + port + '/' + base;
  display = document.getElementById('display-domain');
  display.href = full_url;
  display.title = full_url;
  display.innerHTML = full_url;
  return full_url;
}
