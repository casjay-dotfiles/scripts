function homepage() {
  let proto = location.protocol;
  let port = location.port;
  let currentSite = window.location.hostname;
  window.location = proto + '//' + currentSite + ':' + port;
}
