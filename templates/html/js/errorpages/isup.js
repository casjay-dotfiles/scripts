function isupme() {
  let proto = location.protocol;
  let port = location.port;
  let currentSite = window.location.hostname;
  fullurllocation = proto + '//' + currentSite + ':' + port;
  window.location = 'http://isup.me/' + fullurllocation;
}
