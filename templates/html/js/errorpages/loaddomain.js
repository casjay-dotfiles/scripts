function loadDomain() {
  let proto = location.protocol;
  let port = location.port;
  let url = location.hostname;
  var display = document.getElementById('display-domain');
  display.innerHTML = proto + '//' + url + ':' + port;
}
