"use strict";

var load_main_init = function load_main_init() {
  var myfilename = 'localhost' + location.pathname;
  var myhostname = window.location.origin || myfilename;

  var e,
      r = (e = {}, new URLSearchParams(document.location.search).forEach(function (r, t) {
    var o = decodeURIComponent(t),
        n = decodeURIComponent(r);
    if (o.endsWith('[]')) o = o.replace('[]', ''), e[o] || (e[o] = []), e[o].push(n);else {
      var a = o.match(/\[([a-z0-9_\/\s,.-])+\]$/g);
      a ? (o = o.replace(a, ''), a = a[0].replace('[', '').replace(']', ''), e[o] || (e[o] = []), e[o][a] = n) : e[o] = n;
    }
  }), e),
      t = myhostname,
      o = function o(e) {
    return e = e.split('//')[1];
  },
      n = document.querySelector('.domain');

  if ((!n.innerHTML && t && t.includes('//') || r.domain) && (t = o(t), t = r.domain || t, n.innerText = t), t && (t = o(t), document.title = t + ' — ' + document.title), r.title && (document.querySelector('.default-title').innerText = r.title), r.message && (document.querySelector('.message').innerText = r.message), r.error) {
    var a = document.querySelector('.error'),
        c = document.querySelector('.error-message').querySelector('a');
    a.innerText = r.error, c.href = c.href.replace('$1', r.error);
  }

  document.querySelector('.veil-vm.bg').classList.add('bg-0');
};
