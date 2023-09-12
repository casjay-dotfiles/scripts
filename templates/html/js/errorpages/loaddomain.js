function loadDomain() {
  let port = location.port;
  let url = location.hostname;
  let proto = location.protocol;
  var display = document.getElementById('display-domain');
  display.innerHTML = proto + '//' + url + ':' + port;
}
