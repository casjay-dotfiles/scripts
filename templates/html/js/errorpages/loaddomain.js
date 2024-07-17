function loadDomain() {
  let proto = location.protocol;
  let port = location.port;
  let url = location.hostname;
  var display = document.getElementById('display-domain');
  display.innerHTML = `${req.protocol}://${req.get('host')}/${req.originalUrl}`;
}
