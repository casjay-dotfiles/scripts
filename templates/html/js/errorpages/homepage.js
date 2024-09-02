function homepage(getURI) {
  let baseURI = getURI;
  let port = location.port;
  let url = location.hostname;
  let proto = location.protocol;
  let baseURL = baseURI || location.pathname;
  let base = baseURL.slice(0, baseURL.lastIndexOf('/'));
  if (!base) base = '/';
  if (!port)
    if (proto == 'https:') {
      port = 443;
    } else {
      port = 80;
    }
  window.location = proto + '//' + url + ':' + port + base;
}
