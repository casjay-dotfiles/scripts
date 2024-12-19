function loadLocation(getURI, getID, getMessage) {
  let id = getID;
  let baseURI = getURI;
  let message = getMessage;
  let port = location.port;
  let url = location.hostname;
  let proto = location.protocol;
  let baseURL = baseURI || location.pathname;
  let base = baseURL.slice(0, baseURL.lastIndexOf('/'));
  if (!id) id = 'display-location';
  if (!base) base = '/';
  if (!port)
    if (proto == 'https:') {
      port = 443;
    } else {
      port = 80;
    }
  console.log('Base: ' + base);
  full_url = proto + '//' + url + ':' + port + base;
  display = document.getElementById(id);
  display.href = full_url;
  display.title = full_url;
  message = message || '<div style="font-size:1.3rem;">Return to homepage</div>';
  display.innerHTML = message;
  return full_url;
}
