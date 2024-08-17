function loadDomain() {
  let proto = location.protocol;
  let port = location.port || 80;
  let url = location.hostname;
  if (proto == 'https:') {
    port = location.port || 443;
  }
}
