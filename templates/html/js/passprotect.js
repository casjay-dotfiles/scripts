!(function (e) {
  var t = {};
  function n(o) {
    if (t[o]) return t[o].exports;
    var i = (t[o] = { i: o, l: !1, exports: {} });
    return e[o].call(i.exports, i, i.exports, n), (i.l = !0), i.exports;
  }
  (n.m = e),
    (n.c = t),
    (n.d = function (e, t, o) {
      n.o(e, t) ||
        Object.defineProperty(e, t, {
          configurable: !1,
          enumerable: !0,
          get: o,
        });
    }),
    (n.r = function (e) {
      Object.defineProperty(e, '__esModule', { value: !0 });
    }),
    (n.n = function (e) {
      var t =
        e && e.__esModule
          ? function () {
              return e.default;
            }
          : function () {
              return e;
            };
      return n.d(t, 'a', t), t;
    }),
    (n.o = function (e, t) {
      return Object.prototype.hasOwnProperty.call(e, t);
    }),
    (n.p = ''),
    n((n.s = 14));
})([
  function (e, t, n) {
    (function (t) {
      var n;
      e.exports = (function e(t, o, i) {
        function r(s, l) {
          if (!o[s]) {
            if (!t[s]) {
              var c = 'function' == typeof n && n;
              if (!l && c) return n(s, !0);
              if (a) return a(s, !0);
              var u = new Error("Cannot find module '" + s + "'");
              throw ((u.code = 'MODULE_NOT_FOUND'), u);
            }
            var f = (o[s] = { exports: {} });
            t[s][0].call(
              f.exports,
              function (e) {
                var n = t[s][1][e];
                return r(n || e);
              },
              f,
              f.exports,
              e,
              t,
              o,
              i
            );
          }
          return o[s].exports;
        }
        for (var a = 'function' == typeof n && n, s = 0; s < i.length; s++)
          r(i[s]);
        return r;
      })(
        {
          1: [
            function (e, t, n) {
              'document' in window.self &&
                (('classList' in document.createElement('_') &&
                  (!document.createElementNS ||
                    'classList' in
                      document.createElementNS(
                        'http://www.w3.org/2000/svg',
                        'g'
                      ))) ||
                  (function (e) {
                    'use strict';
                    if ('Element' in e) {
                      var t = 'classList',
                        n = 'prototype',
                        o = e.Element[n],
                        i = Object,
                        r =
                          String[n].trim ||
                          function () {
                            return this.replace(/^\s+|\s+$/g, '');
                          },
                        a =
                          Array[n].indexOf ||
                          function (e) {
                            for (var t = 0, n = this.length; t < n; t++)
                              if (t in this && this[t] === e) return t;
                            return -1;
                          },
                        s = function (e, t) {
                          (this.name = e),
                            (this.code = DOMException[e]),
                            (this.message = t);
                        },
                        l = function (e, t) {
                          if ('' === t)
                            throw new s(
                              'SYNTAX_ERR',
                              'An invalid or illegal string was specified'
                            );
                          if (/\s/.test(t))
                            throw new s(
                              'INVALID_CHARACTER_ERR',
                              'String contains an invalid character'
                            );
                          return a.call(e, t);
                        },
                        c = function (e) {
                          for (
                            var t = r.call(e.getAttribute('class') || ''),
                              n = t ? t.split(/\s+/) : [],
                              o = 0,
                              i = n.length;
                            o < i;
                            o++
                          )
                            this.push(n[o]);
                          this._updateClassName = function () {
                            e.setAttribute('class', this.toString());
                          };
                        },
                        u = (c[n] = []),
                        f = function () {
                          return new c(this);
                        };
                      if (
                        ((s[n] = Error[n]),
                        (u.item = function (e) {
                          return this[e] || null;
                        }),
                        (u.contains = function (e) {
                          return -1 !== l(this, (e += ''));
                        }),
                        (u.add = function () {
                          for (
                            var e, t = arguments, n = 0, o = t.length, i = !1;
                            (e = t[n] + ''),
                              -1 === l(this, e) && (this.push(e), (i = !0)),
                              ++n < o;

                          );
                          i && this._updateClassName();
                        }),
                        (u.remove = function () {
                          var e,
                            t,
                            n = arguments,
                            o = 0,
                            i = n.length,
                            r = !1;
                          do {
                            for (e = n[o] + '', t = l(this, e); -1 !== t; )
                              this.splice(t, 1), (r = !0), (t = l(this, e));
                          } while (++o < i);
                          r && this._updateClassName();
                        }),
                        (u.toggle = function (e, t) {
                          e += '';
                          var n = this.contains(e),
                            o = n ? !0 !== t && 'remove' : !1 !== t && 'add';
                          return o && this[o](e), !0 === t || !1 === t ? t : !n;
                        }),
                        (u.toString = function () {
                          return this.join(' ');
                        }),
                        i.defineProperty)
                      ) {
                        var d = { get: f, enumerable: !0, configurable: !0 };
                        try {
                          i.defineProperty(o, t, d);
                        } catch (e) {
                          (void 0 !== e.number && -2146823252 !== e.number) ||
                            ((d.enumerable = !1), i.defineProperty(o, t, d));
                        }
                      } else i[n].__defineGetter__ && o.__defineGetter__(t, f);
                    }
                  })(window.self),
                (function () {
                  'use strict';
                  var e = document.createElement('_');
                  if (
                    (e.classList.add('c1', 'c2'), !e.classList.contains('c2'))
                  ) {
                    var t = function (e) {
                      var t = DOMTokenList.prototype[e];
                      DOMTokenList.prototype[e] = function (e) {
                        var n,
                          o = arguments.length;
                        for (n = 0; n < o; n++)
                          (e = arguments[n]), t.call(this, e);
                      };
                    };
                    t('add'), t('remove');
                  }
                  if (
                    (e.classList.toggle('c3', !1), e.classList.contains('c3'))
                  ) {
                    var n = DOMTokenList.prototype.toggle;
                    DOMTokenList.prototype.toggle = function (e, t) {
                      return 1 in arguments && !this.contains(e) == !t
                        ? t
                        : n.call(this, e);
                    };
                  }
                  e = null;
                })());
            },
            {},
          ],
          2: [
            function (e, t, n) {
              t.exports = function (e, t) {
                if ('string' != typeof e)
                  throw new TypeError('String expected');
                t || (t = document);
                var n = /<([\w:]+)/.exec(e);
                if (!n) return t.createTextNode(e);
                e = e.replace(/^\s+|\s+$/g, '');
                var o = n[1];
                if ('body' == o) {
                  var i = t.createElement('html');
                  return (i.innerHTML = e), i.removeChild(i.lastChild);
                }
                var a = r[o] || r._default,
                  s = a[0],
                  l = a[1],
                  c = a[2];
                for ((i = t.createElement('div')).innerHTML = l + e + c; s--; )
                  i = i.lastChild;
                if (i.firstChild == i.lastChild)
                  return i.removeChild(i.firstChild);
                for (var u = t.createDocumentFragment(); i.firstChild; )
                  u.appendChild(i.removeChild(i.firstChild));
                return u;
              };
              var o,
                i = !1;
              'undefined' != typeof document &&
                (((o = document.createElement('div')).innerHTML =
                  '  <link/><table></table><a href="/a">a</a><input type="checkbox"/>'),
                (i = !o.getElementsByTagName('link').length),
                (o = void 0));
              var r = {
                legend: [1, '<fieldset>', '</fieldset>'],
                tr: [2, '<table><tbody>', '</tbody></table>'],
                col: [
                  2,
                  '<table><tbody></tbody><colgroup>',
                  '</colgroup></table>',
                ],
                _default: i ? [1, 'X<div>', '</div>'] : [0, '', ''],
              };
              (r.td = r.th =
                [3, '<table><tbody><tr>', '</tr></tbody></table>']),
                (r.option = r.optgroup =
                  [1, '<select multiple="multiple">', '</select>']),
                (r.thead =
                  r.tbody =
                  r.colgroup =
                  r.caption =
                  r.tfoot =
                    [1, '<table>', '</table>']),
                (r.polyline =
                  r.ellipse =
                  r.polygon =
                  r.circle =
                  r.text =
                  r.line =
                  r.path =
                  r.rect =
                  r.g =
                    [
                      1,
                      '<svg xmlns="http://www.w3.org/2000/svg" version="1.1">',
                      '</svg>',
                    ]);
            },
            {},
          ],
          3: [
            function (e, t, n) {
              'use strict';
              function o(e, t) {
                if (null == e)
                  throw new TypeError(
                    'Cannot convert first argument to object'
                  );
                for (var n = Object(e), o = 1; o < arguments.length; o++) {
                  var i = arguments[o];
                  if (null != i)
                    for (
                      var r = Object.keys(Object(i)), a = 0, s = r.length;
                      a < s;
                      a++
                    ) {
                      var l = r[a],
                        c = Object.getOwnPropertyDescriptor(i, l);
                      void 0 !== c && c.enumerable && (n[l] = i[l]);
                    }
                }
                return n;
              }
              t.exports = {
                assign: o,
                polyfill: function () {
                  Object.assign ||
                    Object.defineProperty(Object, 'assign', {
                      enumerable: !1,
                      configurable: !0,
                      writable: !0,
                      value: o,
                    });
                },
              };
            },
            {},
          ],
          4: [
            function (e, t, n) {
              var o = /^(?:submit|button|image|reset|file)$/i,
                i = /^(?:input|select|textarea|keygen)/i,
                r = /(\[[^\[\]]*\])/g;
              function a(e, t, n) {
                if (t.match(r))
                  !(function e(t, n, o) {
                    if (0 === n.length) return (t = o);
                    var i = n.shift(),
                      r = i.match(/^\[(.+?)\]$/);
                    if ('[]' === i)
                      return (
                        (t = t || []),
                        Array.isArray(t)
                          ? t.push(e(null, n, o))
                          : ((t._values = t._values || []),
                            t._values.push(e(null, n, o))),
                        t
                      );
                    if (r) {
                      var a = r[1],
                        s = +a;
                      isNaN(s)
                        ? ((t = t || {})[a] = e(t[a], n, o))
                        : ((t = t || [])[s] = e(t[s], n, o));
                    } else t[i] = e(t[i], n, o);
                    return t;
                  })(
                    e,
                    (function (e) {
                      var t = [],
                        n = new RegExp(r),
                        o = /^([^\[\]]*)/.exec(e);
                      for (o[1] && t.push(o[1]); null !== (o = n.exec(e)); )
                        t.push(o[1]);
                      return t;
                    })(t),
                    n
                  );
                else {
                  var o = e[t];
                  o
                    ? (Array.isArray(o) || (e[t] = [o]), e[t].push(n))
                    : (e[t] = n);
                }
                return e;
              }
              function s(e, t, n) {
                return (
                  (n = n.replace(/(\r)?\n/g, '\r\n')),
                  (n = (n = encodeURIComponent(n)).replace(/%20/g, '+')),
                  e + (e ? '&' : '') + encodeURIComponent(t) + '=' + n
                );
              }
              t.exports = function (e, t) {
                'object' != typeof t
                  ? (t = { hash: !!t })
                  : void 0 === t.hash && (t.hash = !0);
                for (
                  var n = t.hash ? {} : '',
                    r = t.serializer || (t.hash ? a : s),
                    l = e && e.elements ? e.elements : [],
                    c = Object.create(null),
                    u = 0;
                  u < l.length;
                  ++u
                ) {
                  var f = l[u];
                  if (
                    (t.disabled || !f.disabled) &&
                    f.name &&
                    i.test(f.nodeName) &&
                    !o.test(f.type)
                  ) {
                    var d = f.name,
                      p = f.value;
                    if (
                      (('checkbox' !== f.type && 'radio' !== f.type) ||
                        f.checked ||
                        (p = void 0),
                      t.empty)
                    ) {
                      if (
                        ('checkbox' !== f.type || f.checked || (p = ''),
                        'radio' === f.type &&
                          (c[f.name] || f.checked
                            ? f.checked && (c[f.name] = !0)
                            : (c[f.name] = !1)),
                        !p && 'radio' == f.type)
                      )
                        continue;
                    } else if (!p) continue;
                    if ('select-multiple' !== f.type) n = r(n, d, p);
                    else {
                      p = [];
                      for (
                        var h = f.options, v = !1, m = 0;
                        m < h.length;
                        ++m
                      ) {
                        var x = h[m],
                          g = t.empty && !x.value,
                          b = x.value || g;
                        x.selected &&
                          b &&
                          ((v = !0),
                          (n =
                            t.hash && '[]' !== d.slice(d.length - 2)
                              ? r(n, d + '[]', x.value)
                              : r(n, d, x.value)));
                      }
                      !v && t.empty && (n = r(n, d, ''));
                    }
                  }
                }
                if (t.empty) for (var d in c) c[d] || (n = r(n, d, ''));
                return n;
              };
            },
            {},
          ],
          5: [
            function (e, n, o) {
              (function (t) {
                !(function (e) {
                  'object' == typeof o && void 0 !== n
                    ? (n.exports = e())
                    : (('undefined' != typeof window
                        ? window
                        : void 0 !== t
                        ? t
                        : 'undefined' != typeof self
                        ? self
                        : this
                      ).vexDialog = e());
                })(function () {
                  return (function t(n, o, i) {
                    function r(s, l) {
                      if (!o[s]) {
                        if (!n[s]) {
                          var c = 'function' == typeof e && e;
                          if (!l && c) return c(s, !0);
                          if (a) return a(s, !0);
                          var u = new Error("Cannot find module '" + s + "'");
                          throw ((u.code = 'MODULE_NOT_FOUND'), u);
                        }
                        var f = (o[s] = { exports: {} });
                        n[s][0].call(
                          f.exports,
                          function (e) {
                            var t = n[s][1][e];
                            return r(t || e);
                          },
                          f,
                          f.exports,
                          t,
                          n,
                          o,
                          i
                        );
                      }
                      return o[s].exports;
                    }
                    for (
                      var a = 'function' == typeof e && e, s = 0;
                      s < i.length;
                      s++
                    )
                      r(i[s]);
                    return r;
                  })(
                    {
                      1: [
                        function (e, t, n) {
                          t.exports = function (e, t) {
                            if ('string' != typeof e)
                              throw new TypeError('String expected');
                            t || (t = document);
                            var n = /<([\w:]+)/.exec(e);
                            if (!n) return t.createTextNode(e);
                            e = e.replace(/^\s+|\s+$/g, '');
                            var o = n[1];
                            if ('body' == o) {
                              var i = t.createElement('html');
                              return (
                                (i.innerHTML = e), i.removeChild(i.lastChild)
                              );
                            }
                            var a = r[o] || r._default,
                              s = a[0],
                              l = a[1],
                              c = a[2];
                            for (
                              (i = t.createElement('div')).innerHTML =
                                l + e + c;
                              s--;

                            )
                              i = i.lastChild;
                            if (i.firstChild == i.lastChild)
                              return i.removeChild(i.firstChild);
                            for (
                              var u = t.createDocumentFragment();
                              i.firstChild;

                            )
                              u.appendChild(i.removeChild(i.firstChild));
                            return u;
                          };
                          var o,
                            i = !1;
                          'undefined' != typeof document &&
                            (((o = document.createElement('div')).innerHTML =
                              '  <link/><table></table><a href="/a">a</a><input type="checkbox"/>'),
                            (i = !o.getElementsByTagName('link').length),
                            (o = void 0));
                          var r = {
                            legend: [1, '<fieldset>', '</fieldset>'],
                            tr: [2, '<table><tbody>', '</tbody></table>'],
                            col: [
                              2,
                              '<table><tbody></tbody><colgroup>',
                              '</colgroup></table>',
                            ],
                            _default: i ? [1, 'X<div>', '</div>'] : [0, '', ''],
                          };
                          (r.td = r.th =
                            [3, '<table><tbody><tr>', '</tr></tbody></table>']),
                            (r.option = r.optgroup =
                              [1, '<select multiple="multiple">', '</select>']),
                            (r.thead =
                              r.tbody =
                              r.colgroup =
                              r.caption =
                              r.tfoot =
                                [1, '<table>', '</table>']),
                            (r.polyline =
                              r.ellipse =
                              r.polygon =
                              r.circle =
                              r.text =
                              r.line =
                              r.path =
                              r.rect =
                              r.g =
                                [
                                  1,
                                  '<svg xmlns="http://www.w3.org/2000/svg" version="1.1">',
                                  '</svg>',
                                ]);
                        },
                        {},
                      ],
                      2: [
                        function (e, t, n) {
                          var o = /^(?:submit|button|image|reset|file)$/i,
                            i = /^(?:input|select|textarea|keygen)/i,
                            r = /(\[[^\[\]]*\])/g;
                          function a(e, t, n) {
                            if (t.match(r))
                              !(function e(t, n, o) {
                                if (0 === n.length) return (t = o);
                                var i = n.shift(),
                                  r = i.match(/^\[(.+?)\]$/);
                                if ('[]' === i)
                                  return (
                                    (t = t || []),
                                    Array.isArray(t)
                                      ? t.push(e(null, n, o))
                                      : ((t._values = t._values || []),
                                        t._values.push(e(null, n, o))),
                                    t
                                  );
                                if (r) {
                                  var a = r[1],
                                    s = +a;
                                  isNaN(s)
                                    ? ((t = t || {})[a] = e(t[a], n, o))
                                    : ((t = t || [])[s] = e(t[s], n, o));
                                } else t[i] = e(t[i], n, o);
                                return t;
                              })(
                                e,
                                (function (e) {
                                  var t = [],
                                    n = new RegExp(r),
                                    o = /^([^\[\]]*)/.exec(e);
                                  for (
                                    o[1] && t.push(o[1]);
                                    null !== (o = n.exec(e));

                                  )
                                    t.push(o[1]);
                                  return t;
                                })(t),
                                n
                              );
                            else {
                              var o = e[t];
                              o
                                ? (Array.isArray(o) || (e[t] = [o]),
                                  e[t].push(n))
                                : (e[t] = n);
                            }
                            return e;
                          }
                          function s(e, t, n) {
                            return (
                              (n = n.replace(/(\r)?\n/g, '\r\n')),
                              (n = (n = encodeURIComponent(n)).replace(
                                /%20/g,
                                '+'
                              )),
                              e +
                                (e ? '&' : '') +
                                encodeURIComponent(t) +
                                '=' +
                                n
                            );
                          }
                          t.exports = function (e, t) {
                            'object' != typeof t
                              ? (t = { hash: !!t })
                              : void 0 === t.hash && (t.hash = !0);
                            for (
                              var n = t.hash ? {} : '',
                                r = t.serializer || (t.hash ? a : s),
                                l = e && e.elements ? e.elements : [],
                                c = Object.create(null),
                                u = 0;
                              u < l.length;
                              ++u
                            ) {
                              var f = l[u];
                              if (
                                (t.disabled || !f.disabled) &&
                                f.name &&
                                i.test(f.nodeName) &&
                                !o.test(f.type)
                              ) {
                                var d = f.name,
                                  p = f.value;
                                if (
                                  (('checkbox' !== f.type &&
                                    'radio' !== f.type) ||
                                    f.checked ||
                                    (p = void 0),
                                  t.empty)
                                ) {
                                  if (
                                    ('checkbox' !== f.type ||
                                      f.checked ||
                                      (p = ''),
                                    'radio' === f.type &&
                                      (c[f.name] || f.checked
                                        ? f.checked && (c[f.name] = !0)
                                        : (c[f.name] = !1)),
                                    !p && 'radio' == f.type)
                                  )
                                    continue;
                                } else if (!p) continue;
                                if ('select-multiple' !== f.type)
                                  n = r(n, d, p);
                                else {
                                  p = [];
                                  for (
                                    var h = f.options, v = !1, m = 0;
                                    m < h.length;
                                    ++m
                                  ) {
                                    var x = h[m],
                                      g = t.empty && !x.value,
                                      b = x.value || g;
                                    x.selected &&
                                      b &&
                                      ((v = !0),
                                      (n =
                                        t.hash && '[]' !== d.slice(d.length - 2)
                                          ? r(n, d + '[]', x.value)
                                          : r(n, d, x.value)));
                                  }
                                  !v && t.empty && (n = r(n, d, ''));
                                }
                              }
                            }
                            if (t.empty)
                              for (var d in c) c[d] || (n = r(n, d, ''));
                            return n;
                          };
                        },
                        {},
                      ],
                      3: [
                        function (e, t, n) {
                          var o = e('domify'),
                            i = e('form-serialize');
                          t.exports = function (e) {
                            var t = {
                              name: 'dialog',
                              open: function (t) {
                                var n = Object.assign(
                                  {},
                                  this.defaultOptions,
                                  t
                                );
                                n.unsafeMessage && !n.message
                                  ? (n.message = n.unsafeMessage)
                                  : n.message &&
                                    (n.message = e._escapeHtml(n.message));
                                var i = (n.unsafeContent = (function (e) {
                                    var t = document.createElement('form');
                                    t.classList.add('vex-dialog-form');
                                    var n = document.createElement('div');
                                    n.classList.add('vex-dialog-message'),
                                      n.appendChild(
                                        e.message instanceof window.Node
                                          ? e.message
                                          : o(e.message)
                                      );
                                    var i = document.createElement('div');
                                    return (
                                      i.classList.add('vex-dialog-input'),
                                      i.appendChild(
                                        e.input instanceof window.Node
                                          ? e.input
                                          : o(e.input)
                                      ),
                                      t.appendChild(n),
                                      t.appendChild(i),
                                      t
                                    );
                                  })(n)),
                                  r = e.open(n),
                                  a = n.beforeClose && n.beforeClose.bind(r);
                                if (
                                  ((r.options.beforeClose = function () {
                                    var e = !a || a();
                                    return e && n.callback(this.value || !1), e;
                                  }.bind(r)),
                                  i.appendChild(
                                    function (e) {
                                      var t = document.createElement('div');
                                      t.classList.add('vex-dialog-buttons');
                                      for (var n = 0; n < e.length; n++) {
                                        var o = e[n],
                                          i = document.createElement('button');
                                        (i.type = o.type),
                                          (i.textContent = o.text),
                                          (i.className = o.className),
                                          i.classList.add('vex-dialog-button'),
                                          0 === n
                                            ? i.classList.add('vex-first')
                                            : n === e.length - 1 &&
                                              i.classList.add('vex-last'),
                                          function (e) {
                                            i.addEventListener(
                                              'click',
                                              function (t) {
                                                e.click &&
                                                  e.click.call(this, t);
                                              }.bind(this)
                                            );
                                          }.bind(this)(o),
                                          t.appendChild(i);
                                      }
                                      return t;
                                    }.call(r, n.buttons)
                                  ),
                                  (r.form = i),
                                  i.addEventListener(
                                    'submit',
                                    n.onSubmit.bind(r)
                                  ),
                                  n.focusFirstInput)
                                ) {
                                  var s = r.contentEl.querySelector(
                                    'button, input, select, textarea'
                                  );
                                  s && s.focus();
                                }
                                return r;
                              },
                              alert: function (e) {
                                return (
                                  'string' == typeof e && (e = { message: e }),
                                  (e = Object.assign(
                                    {},
                                    this.defaultOptions,
                                    this.defaultAlertOptions,
                                    e
                                  )),
                                  this.open(e)
                                );
                              },
                              confirm: function (e) {
                                if (
                                  'object' != typeof e ||
                                  'function' != typeof e.callback
                                )
                                  throw new Error(
                                    'dialog.confirm(options) requires options.callback.'
                                  );
                                return (
                                  (e = Object.assign(
                                    {},
                                    this.defaultOptions,
                                    this.defaultConfirmOptions,
                                    e
                                  )),
                                  this.open(e)
                                );
                              },
                              prompt: function (t) {
                                if (
                                  'object' != typeof t ||
                                  'function' != typeof t.callback
                                )
                                  throw new Error(
                                    'dialog.prompt(options) requires options.callback.'
                                  );
                                var n = Object.assign(
                                    {},
                                    this.defaultOptions,
                                    this.defaultPromptOptions
                                  ),
                                  o = {
                                    unsafeMessage:
                                      '<label for="vex">' +
                                      e._escapeHtml(t.label || n.label) +
                                      '</label>',
                                    input:
                                      '<input name="vex" type="text" class="vex-dialog-prompt-input" placeholder="' +
                                      e._escapeHtml(
                                        t.placeholder || n.placeholder
                                      ) +
                                      '" value="' +
                                      e._escapeHtml(t.value || n.value) +
                                      '" />',
                                  },
                                  i = (t = Object.assign(n, o, t)).callback;
                                return (
                                  (t.callback = function (e) {
                                    if ('object' == typeof e) {
                                      var t = Object.keys(e);
                                      e = t.length ? e[t[0]] : '';
                                    }
                                    i(e);
                                  }),
                                  this.open(t)
                                );
                              },
                              buttons: {
                                YES: {
                                  text: 'OK',
                                  type: 'submit',
                                  className: 'vex-dialog-button-primary',
                                  click: function () {
                                    this.value = !0;
                                  },
                                },
                                NO: {
                                  text: 'Cancel',
                                  type: 'button',
                                  className: 'vex-dialog-button-secondary',
                                  click: function () {
                                    (this.value = !1), this.close();
                                  },
                                },
                              },
                            };
                            return (
                              (t.defaultOptions = {
                                callback: function () {},
                                afterOpen: function () {},
                                message: '',
                                input: '',
                                buttons: [t.buttons.YES, t.buttons.NO],
                                showCloseButton: !1,
                                onSubmit: function (e) {
                                  return (
                                    e.preventDefault(),
                                    this.options.input &&
                                      (this.value = i(this.form, { hash: !0 })),
                                    this.close()
                                  );
                                },
                                focusFirstInput: !0,
                              }),
                              (t.defaultAlertOptions = {
                                buttons: [t.buttons.YES],
                              }),
                              (t.defaultPromptOptions = {
                                label: 'Prompt:',
                                placeholder: '',
                                value: '',
                              }),
                              (t.defaultConfirmOptions = {}),
                              t
                            );
                          };
                        },
                        { domify: 1, 'form-serialize': 2 },
                      ],
                    },
                    {},
                    [3]
                  )(3);
                });
              }.call(
                this,
                void 0 !== t
                  ? t
                  : 'undefined' != typeof self
                  ? self
                  : 'undefined' != typeof window
                  ? window
                  : {}
              ));
            },
            { domify: 2, 'form-serialize': 4 },
          ],
          6: [
            function (e, t, n) {
              var o = e('./vex');
              o.registerPlugin(e('vex-dialog')), (t.exports = o);
            },
            { './vex': 7, 'vex-dialog': 5 },
          ],
          7: [
            function (e, t, n) {
              e('classlist-polyfill'), e('es6-object-assign').polyfill();
              var o = e('domify'),
                i = function (e) {
                  if (void 0 !== e) {
                    var t = document.createElement('div');
                    return (
                      t.appendChild(document.createTextNode(e)), t.innerHTML
                    );
                  }
                  return '';
                },
                r = function (e, t) {
                  if ('string' == typeof t && 0 !== t.length)
                    for (var n = t.split(' '), o = 0; o < n.length; o++) {
                      var i = n[o];
                      i.length && e.classList.add(i);
                    }
                },
                a = (function () {
                  var e = document.createElement('div'),
                    t = {
                      animation: 'animationend',
                      WebkitAnimation: 'webkitAnimationEnd',
                      MozAnimation: 'animationend',
                      OAnimation: 'oanimationend',
                      msAnimation: 'MSAnimationEnd',
                    };
                  for (var n in t) if (void 0 !== e.style[n]) return t[n];
                  return !1;
                })(),
                s = 'vex-closing',
                l = 'vex-open',
                c = {},
                u = 1,
                f = !1,
                d = {
                  open: function (e) {
                    var t = function (e) {
                      console.warn(
                        'The "' +
                          e +
                          '" property is deprecated in vex 3. Use CSS classes and the appropriate "ClassName" options, instead.'
                      ),
                        console.warn(
                          'See http://github.hubspot.com/vex/api/advanced/#options'
                        );
                    };
                    e.css && t('css'),
                      e.overlayCSS && t('overlayCSS'),
                      e.contentCSS && t('contentCSS'),
                      e.closeCSS && t('closeCSS');
                    var n = {};
                    (n.id = u++),
                      (c[n.id] = n),
                      (n.isOpen = !0),
                      (n.close = function () {
                        if (!this.isOpen) return !0;
                        var e = this.options;
                        if (f && !e.escapeButtonCloses) return !1;
                        if (
                          !1 ===
                          function () {
                            return !e.beforeClose || e.beforeClose.call(this);
                          }.bind(this)()
                        )
                          return !1;
                        this.isOpen = !1;
                        var t = window.getComputedStyle(this.contentEl);
                        function n(e) {
                          return (
                            'none' !==
                              t.getPropertyValue(e + 'animation-name') &&
                            '0s' !==
                              t.getPropertyValue(e + 'animation-duration')
                          );
                        }
                        var o =
                            n('') || n('-webkit-') || n('-moz-') || n('-o-'),
                          i = function t() {
                            this.rootEl.parentNode &&
                              (this.rootEl.removeEventListener(a, t),
                              this.overlayEl.removeEventListener(a, t),
                              delete c[this.id],
                              this.rootEl.parentNode.removeChild(this.rootEl),
                              this.bodyEl.removeChild(this.overlayEl),
                              e.afterClose && e.afterClose.call(this),
                              0 === Object.keys(c).length &&
                                document.body.classList.remove(l));
                          }.bind(this);
                        return (
                          a && o
                            ? (this.rootEl.addEventListener(a, i),
                              this.overlayEl.addEventListener(a, i),
                              this.rootEl.classList.add(s),
                              this.overlayEl.classList.add(s))
                            : i(),
                          !0
                        );
                      }),
                      'string' == typeof e && (e = { content: e }),
                      e.unsafeContent && !e.content
                        ? (e.content = e.unsafeContent)
                        : e.content && (e.content = i(e.content));
                    var p = (n.options = Object.assign(
                        {},
                        d.defaultOptions,
                        e
                      )),
                      h = (n.bodyEl = document.getElementsByTagName('body')[0]),
                      v = (n.rootEl = document.createElement('div'));
                    v.classList.add('vex'), r(v, p.className);
                    var m = (n.overlayEl = document.createElement('div'));
                    m.classList.add('vex-overlay'),
                      r(m, p.overlayClassName),
                      p.overlayClosesOnClick &&
                        v.addEventListener('click', function (e) {
                          e.target === v && n.close();
                        }),
                      h.appendChild(m);
                    var x = (n.contentEl = document.createElement('div'));
                    if (
                      (x.classList.add('vex-content'),
                      r(x, p.contentClassName),
                      x.appendChild(
                        p.content instanceof window.Node
                          ? p.content
                          : o(p.content)
                      ),
                      v.appendChild(x),
                      p.showCloseButton)
                    ) {
                      var g = (n.closeEl = document.createElement('div'));
                      g.classList.add('vex-close'),
                        r(g, p.closeClassName),
                        g.addEventListener('click', n.close.bind(n)),
                        x.appendChild(g);
                    }
                    return (
                      document.querySelector(p.appendLocation).appendChild(v),
                      p.afterOpen && p.afterOpen.call(n),
                      document.body.classList.add(l),
                      n
                    );
                  },
                  close: function (e) {
                    var t;
                    if (e.id) t = e.id;
                    else {
                      if ('string' != typeof e)
                        throw new TypeError(
                          'close requires a vex object or id string'
                        );
                      t = e;
                    }
                    return !!c[t] && c[t].close();
                  },
                  closeTop: function () {
                    var e = Object.keys(c);
                    return !!e.length && c[e[e.length - 1]].close();
                  },
                  closeAll: function () {
                    for (var e in c) this.close(e);
                    return !0;
                  },
                  getAll: function () {
                    return c;
                  },
                  getById: function (e) {
                    return c[e];
                  },
                };
              window.addEventListener('keyup', function (e) {
                27 === e.keyCode && ((f = !0), d.closeTop(), (f = !1));
              }),
                window.addEventListener('popstate', function () {
                  d.defaultOptions.closeAllOnPopState && d.closeAll();
                }),
                (d.defaultOptions = {
                  content: '',
                  showCloseButton: !0,
                  escapeButtonCloses: !0,
                  overlayClosesOnClick: !0,
                  appendLocation: 'body',
                  className: '',
                  overlayClassName: '',
                  contentClassName: '',
                  closeClassName: '',
                  closeAllOnPopState: !0,
                }),
                Object.defineProperty(d, '_escapeHtml', {
                  configurable: !1,
                  enumerable: !1,
                  writable: !1,
                  value: i,
                }),
                (d.registerPlugin = function (e, t) {
                  var n = e(d),
                    o = t || n.name;
                  if (d[o])
                    throw new Error('Plugin ' + t + ' is already registered.');
                  d[o] = n;
                }),
                (t.exports = d);
            },
            { 'classlist-polyfill': 1, domify: 2, 'es6-object-assign': 3 },
          ],
        },
        {},
        [6]
      )(6);
    }.call(this, n(4)));
  },
  function (module, exports, __webpack_require__) {
    (function (process, global) {
      var __WEBPACK_AMD_DEFINE_RESULT__;
      /*
       * [js-sha1]{@link https://github.com/emn178/js-sha1}
       *
       * @version 0.6.0
       * @author Chen, Yi-Cyuan [emn178@gmail.com]
       * @copyright Chen, Yi-Cyuan 2014-2017
       * @license MIT
       */
      /*
       * [js-sha1]{@link https://github.com/emn178/js-sha1}
       *
       * @version 0.6.0
       * @author Chen, Yi-Cyuan [emn178@gmail.com]
       * @copyright Chen, Yi-Cyuan 2014-2017
       * @license MIT
       */
      !(function () {
        'use strict';
        var root = 'object' == typeof window ? window : {},
          NODE_JS =
            !root.JS_SHA1_NO_NODE_JS &&
            'object' == typeof process &&
            process.versions &&
            process.versions.node;
        NODE_JS && (root = global);
        var COMMON_JS =
            !root.JS_SHA1_NO_COMMON_JS &&
            'object' == typeof module &&
            module.exports,
          AMD = __webpack_require__(12),
          HEX_CHARS = '0123456789abcdef'.split(''),
          EXTRA = [-2147483648, 8388608, 32768, 128],
          SHIFT = [24, 16, 8, 0],
          OUTPUT_TYPES = ['hex', 'array', 'digest', 'arrayBuffer'],
          blocks = [],
          createOutputMethod = function (e) {
            return function (t) {
              return new Sha1(!0).update(t)[e]();
            };
          },
          createMethod = function () {
            var e = createOutputMethod('hex');
            NODE_JS && (e = nodeWrap(e)),
              (e.create = function () {
                return new Sha1();
              }),
              (e.update = function (t) {
                return e.create().update(t);
              });
            for (var t = 0; t < OUTPUT_TYPES.length; ++t) {
              var n = OUTPUT_TYPES[t];
              e[n] = createOutputMethod(n);
            }
            return e;
          },
          nodeWrap = function (method) {
            var crypto = eval("require('crypto')"),
              Buffer = eval("require('buffer').Buffer"),
              nodeMethod = function (e) {
                if ('string' == typeof e)
                  return crypto
                    .createHash('sha1')
                    .update(e, 'utf8')
                    .digest('hex');
                if (e.constructor === ArrayBuffer) e = new Uint8Array(e);
                else if (void 0 === e.length) return method(e);
                return crypto
                  .createHash('sha1')
                  .update(new Buffer(e))
                  .digest('hex');
              };
            return nodeMethod;
          };
        function Sha1(e) {
          e
            ? ((blocks[0] =
                blocks[16] =
                blocks[1] =
                blocks[2] =
                blocks[3] =
                blocks[4] =
                blocks[5] =
                blocks[6] =
                blocks[7] =
                blocks[8] =
                blocks[9] =
                blocks[10] =
                blocks[11] =
                blocks[12] =
                blocks[13] =
                blocks[14] =
                blocks[15] =
                  0),
              (this.blocks = blocks))
            : (this.blocks = [
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
              ]),
            (this.h0 = 1732584193),
            (this.h1 = 4023233417),
            (this.h2 = 2562383102),
            (this.h3 = 271733878),
            (this.h4 = 3285377520),
            (this.block = this.start = this.bytes = this.hBytes = 0),
            (this.finalized = this.hashed = !1),
            (this.first = !0);
        }
        (Sha1.prototype.update = function (e) {
          if (!this.finalized) {
            var t = 'string' != typeof e;
            t && e.constructor === root.ArrayBuffer && (e = new Uint8Array(e));
            for (var n, o, i = 0, r = e.length || 0, a = this.blocks; i < r; ) {
              if (
                (this.hashed &&
                  ((this.hashed = !1),
                  (a[0] = this.block),
                  (a[16] =
                    a[1] =
                    a[2] =
                    a[3] =
                    a[4] =
                    a[5] =
                    a[6] =
                    a[7] =
                    a[8] =
                    a[9] =
                    a[10] =
                    a[11] =
                    a[12] =
                    a[13] =
                    a[14] =
                    a[15] =
                      0)),
                t)
              )
                for (o = this.start; i < r && o < 64; ++i)
                  a[o >> 2] |= e[i] << SHIFT[3 & o++];
              else
                for (o = this.start; i < r && o < 64; ++i)
                  (n = e.charCodeAt(i)) < 128
                    ? (a[o >> 2] |= n << SHIFT[3 & o++])
                    : n < 2048
                    ? ((a[o >> 2] |= (192 | (n >> 6)) << SHIFT[3 & o++]),
                      (a[o >> 2] |= (128 | (63 & n)) << SHIFT[3 & o++]))
                    : n < 55296 || n >= 57344
                    ? ((a[o >> 2] |= (224 | (n >> 12)) << SHIFT[3 & o++]),
                      (a[o >> 2] |= (128 | ((n >> 6) & 63)) << SHIFT[3 & o++]),
                      (a[o >> 2] |= (128 | (63 & n)) << SHIFT[3 & o++]))
                    : ((n =
                        65536 +
                        (((1023 & n) << 10) | (1023 & e.charCodeAt(++i)))),
                      (a[o >> 2] |= (240 | (n >> 18)) << SHIFT[3 & o++]),
                      (a[o >> 2] |= (128 | ((n >> 12) & 63)) << SHIFT[3 & o++]),
                      (a[o >> 2] |= (128 | ((n >> 6) & 63)) << SHIFT[3 & o++]),
                      (a[o >> 2] |= (128 | (63 & n)) << SHIFT[3 & o++]));
              (this.lastByteIndex = o),
                (this.bytes += o - this.start),
                o >= 64
                  ? ((this.block = a[16]),
                    (this.start = o - 64),
                    this.hash(),
                    (this.hashed = !0))
                  : (this.start = o);
            }
            return (
              this.bytes > 4294967295 &&
                ((this.hBytes += (this.bytes / 4294967296) << 0),
                (this.bytes = this.bytes % 4294967296)),
              this
            );
          }
        }),
          (Sha1.prototype.finalize = function () {
            if (!this.finalized) {
              this.finalized = !0;
              var e = this.blocks,
                t = this.lastByteIndex;
              (e[16] = this.block),
                (e[t >> 2] |= EXTRA[3 & t]),
                (this.block = e[16]),
                t >= 56 &&
                  (this.hashed || this.hash(),
                  (e[0] = this.block),
                  (e[16] =
                    e[1] =
                    e[2] =
                    e[3] =
                    e[4] =
                    e[5] =
                    e[6] =
                    e[7] =
                    e[8] =
                    e[9] =
                    e[10] =
                    e[11] =
                    e[12] =
                    e[13] =
                    e[14] =
                    e[15] =
                      0)),
                (e[14] = (this.hBytes << 3) | (this.bytes >>> 29)),
                (e[15] = this.bytes << 3),
                this.hash();
            }
          }),
          (Sha1.prototype.hash = function () {
            var e,
              t,
              n = this.h0,
              o = this.h1,
              i = this.h2,
              r = this.h3,
              a = this.h4,
              s = this.blocks;
            for (e = 16; e < 80; ++e)
              (t = s[e - 3] ^ s[e - 8] ^ s[e - 14] ^ s[e - 16]),
                (s[e] = (t << 1) | (t >>> 31));
            for (e = 0; e < 20; e += 5)
              (n =
                ((t =
                  ((o =
                    ((t =
                      ((i =
                        ((t =
                          ((r =
                            ((t =
                              ((a =
                                ((t = (n << 5) | (n >>> 27)) +
                                  ((o & i) | (~o & r)) +
                                  a +
                                  1518500249 +
                                  s[e]) <<
                                0) <<
                                5) |
                              (a >>> 27)) +
                              ((n & (o = (o << 30) | (o >>> 2))) | (~n & i)) +
                              r +
                              1518500249 +
                              s[e + 1]) <<
                            0) <<
                            5) |
                          (r >>> 27)) +
                          ((a & (n = (n << 30) | (n >>> 2))) | (~a & o)) +
                          i +
                          1518500249 +
                          s[e + 2]) <<
                        0) <<
                        5) |
                      (i >>> 27)) +
                      ((r & (a = (a << 30) | (a >>> 2))) | (~r & n)) +
                      o +
                      1518500249 +
                      s[e + 3]) <<
                    0) <<
                    5) |
                  (o >>> 27)) +
                  ((i & (r = (r << 30) | (r >>> 2))) | (~i & a)) +
                  n +
                  1518500249 +
                  s[e + 4]) <<
                0),
                (i = (i << 30) | (i >>> 2));
            for (; e < 40; e += 5)
              (n =
                ((t =
                  ((o =
                    ((t =
                      ((i =
                        ((t =
                          ((r =
                            ((t =
                              ((a =
                                ((t = (n << 5) | (n >>> 27)) +
                                  (o ^ i ^ r) +
                                  a +
                                  1859775393 +
                                  s[e]) <<
                                0) <<
                                5) |
                              (a >>> 27)) +
                              (n ^ (o = (o << 30) | (o >>> 2)) ^ i) +
                              r +
                              1859775393 +
                              s[e + 1]) <<
                            0) <<
                            5) |
                          (r >>> 27)) +
                          (a ^ (n = (n << 30) | (n >>> 2)) ^ o) +
                          i +
                          1859775393 +
                          s[e + 2]) <<
                        0) <<
                        5) |
                      (i >>> 27)) +
                      (r ^ (a = (a << 30) | (a >>> 2)) ^ n) +
                      o +
                      1859775393 +
                      s[e + 3]) <<
                    0) <<
                    5) |
                  (o >>> 27)) +
                  (i ^ (r = (r << 30) | (r >>> 2)) ^ a) +
                  n +
                  1859775393 +
                  s[e + 4]) <<
                0),
                (i = (i << 30) | (i >>> 2));
            for (; e < 60; e += 5)
              (n =
                ((t =
                  ((o =
                    ((t =
                      ((i =
                        ((t =
                          ((r =
                            ((t =
                              ((a =
                                ((t = (n << 5) | (n >>> 27)) +
                                  ((o & i) | (o & r) | (i & r)) +
                                  a -
                                  1894007588 +
                                  s[e]) <<
                                0) <<
                                5) |
                              (a >>> 27)) +
                              ((n & (o = (o << 30) | (o >>> 2))) |
                                (n & i) |
                                (o & i)) +
                              r -
                              1894007588 +
                              s[e + 1]) <<
                            0) <<
                            5) |
                          (r >>> 27)) +
                          ((a & (n = (n << 30) | (n >>> 2))) |
                            (a & o) |
                            (n & o)) +
                          i -
                          1894007588 +
                          s[e + 2]) <<
                        0) <<
                        5) |
                      (i >>> 27)) +
                      ((r & (a = (a << 30) | (a >>> 2))) | (r & n) | (a & n)) +
                      o -
                      1894007588 +
                      s[e + 3]) <<
                    0) <<
                    5) |
                  (o >>> 27)) +
                  ((i & (r = (r << 30) | (r >>> 2))) | (i & a) | (r & a)) +
                  n -
                  1894007588 +
                  s[e + 4]) <<
                0),
                (i = (i << 30) | (i >>> 2));
            for (; e < 80; e += 5)
              (n =
                ((t =
                  ((o =
                    ((t =
                      ((i =
                        ((t =
                          ((r =
                            ((t =
                              ((a =
                                ((t = (n << 5) | (n >>> 27)) +
                                  (o ^ i ^ r) +
                                  a -
                                  899497514 +
                                  s[e]) <<
                                0) <<
                                5) |
                              (a >>> 27)) +
                              (n ^ (o = (o << 30) | (o >>> 2)) ^ i) +
                              r -
                              899497514 +
                              s[e + 1]) <<
                            0) <<
                            5) |
                          (r >>> 27)) +
                          (a ^ (n = (n << 30) | (n >>> 2)) ^ o) +
                          i -
                          899497514 +
                          s[e + 2]) <<
                        0) <<
                        5) |
                      (i >>> 27)) +
                      (r ^ (a = (a << 30) | (a >>> 2)) ^ n) +
                      o -
                      899497514 +
                      s[e + 3]) <<
                    0) <<
                    5) |
                  (o >>> 27)) +
                  (i ^ (r = (r << 30) | (r >>> 2)) ^ a) +
                  n -
                  899497514 +
                  s[e + 4]) <<
                0),
                (i = (i << 30) | (i >>> 2));
            (this.h0 = (this.h0 + n) << 0),
              (this.h1 = (this.h1 + o) << 0),
              (this.h2 = (this.h2 + i) << 0),
              (this.h3 = (this.h3 + r) << 0),
              (this.h4 = (this.h4 + a) << 0);
          }),
          (Sha1.prototype.hex = function () {
            this.finalize();
            var e = this.h0,
              t = this.h1,
              n = this.h2,
              o = this.h3,
              i = this.h4;
            return (
              HEX_CHARS[(e >> 28) & 15] +
              HEX_CHARS[(e >> 24) & 15] +
              HEX_CHARS[(e >> 20) & 15] +
              HEX_CHARS[(e >> 16) & 15] +
              HEX_CHARS[(e >> 12) & 15] +
              HEX_CHARS[(e >> 8) & 15] +
              HEX_CHARS[(e >> 4) & 15] +
              HEX_CHARS[15 & e] +
              HEX_CHARS[(t >> 28) & 15] +
              HEX_CHARS[(t >> 24) & 15] +
              HEX_CHARS[(t >> 20) & 15] +
              HEX_CHARS[(t >> 16) & 15] +
              HEX_CHARS[(t >> 12) & 15] +
              HEX_CHARS[(t >> 8) & 15] +
              HEX_CHARS[(t >> 4) & 15] +
              HEX_CHARS[15 & t] +
              HEX_CHARS[(n >> 28) & 15] +
              HEX_CHARS[(n >> 24) & 15] +
              HEX_CHARS[(n >> 20) & 15] +
              HEX_CHARS[(n >> 16) & 15] +
              HEX_CHARS[(n >> 12) & 15] +
              HEX_CHARS[(n >> 8) & 15] +
              HEX_CHARS[(n >> 4) & 15] +
              HEX_CHARS[15 & n] +
              HEX_CHARS[(o >> 28) & 15] +
              HEX_CHARS[(o >> 24) & 15] +
              HEX_CHARS[(o >> 20) & 15] +
              HEX_CHARS[(o >> 16) & 15] +
              HEX_CHARS[(o >> 12) & 15] +
              HEX_CHARS[(o >> 8) & 15] +
              HEX_CHARS[(o >> 4) & 15] +
              HEX_CHARS[15 & o] +
              HEX_CHARS[(i >> 28) & 15] +
              HEX_CHARS[(i >> 24) & 15] +
              HEX_CHARS[(i >> 20) & 15] +
              HEX_CHARS[(i >> 16) & 15] +
              HEX_CHARS[(i >> 12) & 15] +
              HEX_CHARS[(i >> 8) & 15] +
              HEX_CHARS[(i >> 4) & 15] +
              HEX_CHARS[15 & i]
            );
          }),
          (Sha1.prototype.toString = Sha1.prototype.hex),
          (Sha1.prototype.digest = function () {
            this.finalize();
            var e = this.h0,
              t = this.h1,
              n = this.h2,
              o = this.h3,
              i = this.h4;
            return [
              (e >> 24) & 255,
              (e >> 16) & 255,
              (e >> 8) & 255,
              255 & e,
              (t >> 24) & 255,
              (t >> 16) & 255,
              (t >> 8) & 255,
              255 & t,
              (n >> 24) & 255,
              (n >> 16) & 255,
              (n >> 8) & 255,
              255 & n,
              (o >> 24) & 255,
              (o >> 16) & 255,
              (o >> 8) & 255,
              255 & o,
              (i >> 24) & 255,
              (i >> 16) & 255,
              (i >> 8) & 255,
              255 & i,
            ];
          }),
          (Sha1.prototype.array = Sha1.prototype.digest),
          (Sha1.prototype.arrayBuffer = function () {
            this.finalize();
            var e = new ArrayBuffer(20),
              t = new DataView(e);
            return (
              t.setUint32(0, this.h0),
              t.setUint32(4, this.h1),
              t.setUint32(8, this.h2),
              t.setUint32(12, this.h3),
              t.setUint32(16, this.h4),
              e
            );
          });
        var exports = createMethod();
        COMMON_JS
          ? (module.exports = exports)
          : ((root.sha1 = exports),
            AMD &&
              ((__WEBPACK_AMD_DEFINE_RESULT__ = function () {
                return exports;
              }.call(exports, __webpack_require__, exports, module)),
              void 0 === __WEBPACK_AMD_DEFINE_RESULT__ ||
                (module.exports = __WEBPACK_AMD_DEFINE_RESULT__)));
      })();
    }.call(this, __webpack_require__(13), __webpack_require__(4)));
  },
  function (e, t, n) {
    var o,
      i,
      r = {},
      a =
        ((o = function () {
          return window && document && document.all && !window.atob;
        }),
        function () {
          return void 0 === i && (i = o.apply(this, arguments)), i;
        }),
      s = (function (e) {
        var t = {};
        return function (e) {
          if ('function' == typeof e) return e();
          if (void 0 === t[e]) {
            var n = function (e) {
              return document.querySelector(e);
            }.call(this, e);
            if (
              window.HTMLIFrameElement &&
              n instanceof window.HTMLIFrameElement
            )
              try {
                n = n.contentDocument.head;
              } catch (e) {
                n = null;
              }
            t[e] = n;
          }
          return t[e];
        };
      })(),
      l = null,
      c = 0,
      u = [],
      f = n(9);
    function d(e, t) {
      for (var n = 0; n < e.length; n++) {
        var o = e[n],
          i = r[o.id];
        if (i) {
          i.refs++;
          for (var a = 0; a < i.parts.length; a++) i.parts[a](o.parts[a]);
          for (; a < o.parts.length; a++) i.parts.push(g(o.parts[a], t));
        } else {
          var s = [];
          for (a = 0; a < o.parts.length; a++) s.push(g(o.parts[a], t));
          r[o.id] = { id: o.id, refs: 1, parts: s };
        }
      }
    }
    function p(e, t) {
      for (var n = [], o = {}, i = 0; i < e.length; i++) {
        var r = e[i],
          a = t.base ? r[0] + t.base : r[0],
          s = { css: r[1], media: r[2], sourceMap: r[3] };
        o[a] ? o[a].parts.push(s) : n.push((o[a] = { id: a, parts: [s] }));
      }
      return n;
    }
    function h(e, t) {
      var n = s(e.insertInto);
      if (!n)
        throw new Error(
          "Couldn't find a style target. This probably means that the value for the 'insertInto' parameter is invalid."
        );
      var o = u[u.length - 1];
      if ('top' === e.insertAt)
        o
          ? o.nextSibling
            ? n.insertBefore(t, o.nextSibling)
            : n.appendChild(t)
          : n.insertBefore(t, n.firstChild),
          u.push(t);
      else if ('bottom' === e.insertAt) n.appendChild(t);
      else {
        if ('object' != typeof e.insertAt || !e.insertAt.before)
          throw new Error(
            "[Style Loader]\n\n Invalid value for parameter 'insertAt' ('options.insertAt') found.\n Must be 'top', 'bottom', or Object.\n (https://github.com/webpack-contrib/style-loader#insertat)\n"
          );
        var i = s(e.insertInto + ' ' + e.insertAt.before);
        n.insertBefore(t, i);
      }
    }
    function v(e) {
      if (null === e.parentNode) return !1;
      e.parentNode.removeChild(e);
      var t = u.indexOf(e);
      t >= 0 && u.splice(t, 1);
    }
    function m(e) {
      var t = document.createElement('style');
      return (
        void 0 === e.attrs.type && (e.attrs.type = 'text/css'),
        x(t, e.attrs),
        h(e, t),
        t
      );
    }
    function x(e, t) {
      Object.keys(t).forEach(function (n) {
        e.setAttribute(n, t[n]);
      });
    }
    function g(e, t) {
      var n, o, i, r;
      if (t.transform && e.css) {
        if (!(r = t.transform(e.css))) return function () {};
        e.css = r;
      }
      if (t.singleton) {
        var a = c++;
        (n = l || (l = m(t))),
          (o = w.bind(null, n, a, !1)),
          (i = w.bind(null, n, a, !0));
      } else
        e.sourceMap &&
        'function' == typeof URL &&
        'function' == typeof URL.createObjectURL &&
        'function' == typeof URL.revokeObjectURL &&
        'function' == typeof Blob &&
        'function' == typeof btoa
          ? ((n = (function (e) {
              var t = document.createElement('link');
              return (
                void 0 === e.attrs.type && (e.attrs.type = 'text/css'),
                (e.attrs.rel = 'stylesheet'),
                x(t, e.attrs),
                h(e, t),
                t
              );
            })(t)),
            (o = function (e, t, n) {
              var o = n.css,
                i = n.sourceMap,
                r = void 0 === t.convertToAbsoluteUrls && i;
              (t.convertToAbsoluteUrls || r) && (o = f(o));
              i &&
                (o +=
                  '\n/*# sourceMappingURL=data:application/json;base64,' +
                  btoa(unescape(encodeURIComponent(JSON.stringify(i)))) +
                  ' */');
              var a = new Blob([o], { type: 'text/css' }),
                s = e.href;
              (e.href = URL.createObjectURL(a)), s && URL.revokeObjectURL(s);
            }.bind(null, n, t)),
            (i = function () {
              v(n), n.href && URL.revokeObjectURL(n.href);
            }))
          : ((n = m(t)),
            (o = function (e, t) {
              var n = t.css,
                o = t.media;
              o && e.setAttribute('media', o);
              if (e.styleSheet) e.styleSheet.cssText = n;
              else {
                for (; e.firstChild; ) e.removeChild(e.firstChild);
                e.appendChild(document.createTextNode(n));
              }
            }.bind(null, n)),
            (i = function () {
              v(n);
            }));
      return (
        o(e),
        function (t) {
          if (t) {
            if (
              t.css === e.css &&
              t.media === e.media &&
              t.sourceMap === e.sourceMap
            )
              return;
            o((e = t));
          } else i();
        }
      );
    }
    e.exports = function (e, t) {
      if ('undefined' != typeof DEBUG && DEBUG && 'object' != typeof document)
        throw new Error(
          'The style-loader cannot be used in a non-browser environment'
        );
      ((t = t || {}).attrs = 'object' == typeof t.attrs ? t.attrs : {}),
        t.singleton || 'boolean' == typeof t.singleton || (t.singleton = a()),
        t.insertInto || (t.insertInto = 'head'),
        t.insertAt || (t.insertAt = 'bottom');
      var n = p(e, t);
      return (
        d(n, t),
        function (e) {
          for (var o = [], i = 0; i < n.length; i++) {
            var a = n[i];
            (s = r[a.id]).refs--, o.push(s);
          }
          e && d(p(e, t), t);
          for (i = 0; i < o.length; i++) {
            var s;
            if (0 === (s = o[i]).refs) {
              for (var l = 0; l < s.parts.length; l++) s.parts[l]();
              delete r[s.id];
            }
          }
        }
      );
    };
    var b,
      y =
        ((b = []),
        function (e, t) {
          return (b[e] = t), b.filter(Boolean).join('\n');
        });
    function w(e, t, n, o) {
      var i = n ? '' : o.css;
      if (e.styleSheet) e.styleSheet.cssText = y(t, i);
      else {
        var r = document.createTextNode(i),
          a = e.childNodes;
        a[t] && e.removeChild(a[t]),
          a.length ? e.insertBefore(r, a[t]) : e.appendChild(r);
      }
    }
  },
  function (e, t) {
    e.exports = function (e) {
      var t = [];
      return (
        (t.toString = function () {
          return this.map(function (t) {
            var n = (function (e, t) {
              var n = e[1] || '',
                o = e[3];
              if (!o) return n;
              if (t && 'function' == typeof btoa) {
                var i =
                    ((a = o),
                    '/*# sourceMappingURL=data:application/json;charset=utf-8;base64,' +
                      btoa(unescape(encodeURIComponent(JSON.stringify(a)))) +
                      ' */'),
                  r = o.sources.map(function (e) {
                    return '/*# sourceURL=' + o.sourceRoot + e + ' */';
                  });
                return [n].concat(r).concat([i]).join('\n');
              }
              var a;
              return [n].join('\n');
            })(t, e);
            return t[2] ? '@media ' + t[2] + '{' + n + '}' : n;
          }).join('');
        }),
        (t.i = function (e, n) {
          'string' == typeof e && (e = [[null, e, '']]);
          for (var o = {}, i = 0; i < this.length; i++) {
            var r = this[i][0];
            'number' == typeof r && (o[r] = !0);
          }
          for (i = 0; i < e.length; i++) {
            var a = e[i];
            ('number' == typeof a[0] && o[a[0]]) ||
              (n && !a[2]
                ? (a[2] = n)
                : n && (a[2] = '(' + a[2] + ') and (' + n + ')'),
              t.push(a));
          }
        }),
        t
      );
    };
  },
  function (e, t) {
    var n;
    n = (function () {
      return this;
    })();
    try {
      n = n || Function('return this')() || (0, eval)('this');
    } catch (e) {
      'object' == typeof window && (n = window);
    }
    e.exports = n;
  },
  function (e, t, n) {
    (e.exports = n(3)(!1)).push([
      e.i,
      '.vex-dialog-message {\n  font-weight: bold;\n  text-align: center;\n}\n\n.vex-dialog-input p {\n  margin-bottom: 1em;\n}\n',
      '',
    ]);
  },
  function (e, t, n) {
    var o = n(5);
    'string' == typeof o && (o = [[e.i, o, '']]);
    var i = { hmr: !0, transform: void 0, insertInto: void 0 };
    n(2)(o, i);
    o.locals && (e.exports = o.locals);
  },
  function (e, t, n) {
    (e.exports = n(3)(!1)).push([
      e.i,
      '@-webkit-keyframes vex-pulse {\n  0% {\n    box-shadow: inset 0 0 0 300px transparent; }\n  70% {\n    box-shadow: inset 0 0 0 300px rgba(255, 255, 255, 0.25); }\n  100% {\n    box-shadow: inset 0 0 0 300px transparent; } }\n\n@keyframes vex-pulse {\n  0% {\n    box-shadow: inset 0 0 0 300px transparent; }\n  70% {\n    box-shadow: inset 0 0 0 300px rgba(255, 255, 255, 0.25); }\n  100% {\n    box-shadow: inset 0 0 0 300px transparent; } }\n\n.vex.vex-theme-wireframe {\n  padding-top: 160px;\n  padding-bottom: 160px; }\n  .vex.vex-theme-wireframe .vex-overlay {\n    background: rgba(255, 255, 255, 0.4); }\n  .vex.vex-theme-wireframe .vex-content {\n    font-family: "Helvetica Neue", sans-serif;\n    background: #fff;\n    color: #000;\n    border: 2px solid #000;\n    padding: 2em;\n    position: relative;\n    margin: 0 auto;\n    max-width: 100%;\n    width: 400px;\n    font-size: 1.1em;\n    line-height: 1.5em; }\n    .vex.vex-theme-wireframe .vex-content h1, .vex.vex-theme-wireframe .vex-content h2, .vex.vex-theme-wireframe .vex-content h3, .vex.vex-theme-wireframe .vex-content h4, .vex.vex-theme-wireframe .vex-content h5, .vex.vex-theme-wireframe .vex-content h6, .vex.vex-theme-wireframe .vex-content p, .vex.vex-theme-wireframe .vex-content ul, .vex.vex-theme-wireframe .vex-content li {\n      color: inherit; }\n  .vex.vex-theme-wireframe .vex-close {\n    position: absolute;\n    top: 0;\n    right: 0;\n    cursor: pointer; }\n    .vex.vex-theme-wireframe .vex-close:before {\n      position: absolute;\n      content: "\\D7";\n      font-size: 40px;\n      font-weight: normal;\n      line-height: 80px;\n      height: 80px;\n      width: 80px;\n      text-align: center;\n      top: 3px;\n      right: 3px;\n      color: #000; }\n    .vex.vex-theme-wireframe .vex-close:hover:before, .vex.vex-theme-wireframe .vex-close:active:before {\n      color: #000; }\n  .vex.vex-theme-wireframe .vex-dialog-form .vex-dialog-message {\n    margin-bottom: .5em; }\n  .vex.vex-theme-wireframe .vex-dialog-form .vex-dialog-input {\n    margin-bottom: 1em; }\n    .vex.vex-theme-wireframe .vex-dialog-form .vex-dialog-input select, .vex.vex-theme-wireframe .vex-dialog-form .vex-dialog-input textarea, .vex.vex-theme-wireframe .vex-dialog-form .vex-dialog-input input[type="date"], .vex.vex-theme-wireframe .vex-dialog-form .vex-dialog-input input[type="datetime"], .vex.vex-theme-wireframe .vex-dialog-form .vex-dialog-input input[type="datetime-local"], .vex.vex-theme-wireframe .vex-dialog-form .vex-dialog-input input[type="email"], .vex.vex-theme-wireframe .vex-dialog-form .vex-dialog-input input[type="month"], .vex.vex-theme-wireframe .vex-dialog-form .vex-dialog-input input[type="number"], .vex.vex-theme-wireframe .vex-dialog-form .vex-dialog-input input[type="password"], .vex.vex-theme-wireframe .vex-dialog-form .vex-dialog-input input[type="search"], .vex.vex-theme-wireframe .vex-dialog-form .vex-dialog-input input[type="tel"], .vex.vex-theme-wireframe .vex-dialog-form .vex-dialog-input input[type="text"], .vex.vex-theme-wireframe .vex-dialog-form .vex-dialog-input input[type="time"], .vex.vex-theme-wireframe .vex-dialog-form .vex-dialog-input input[type="url"], .vex.vex-theme-wireframe .vex-dialog-form .vex-dialog-input input[type="week"] {\n      background: #fff;\n      width: 100%;\n      padding: .25em .67em;\n      font-family: inherit;\n      font-weight: inherit;\n      font-size: inherit;\n      min-height: 2.5em;\n      margin: 0 0 .25em;\n      border: 2px solid #000; }\n      .vex.vex-theme-wireframe .vex-dialog-form .vex-dialog-input select:focus, .vex.vex-theme-wireframe .vex-dialog-form .vex-dialog-input textarea:focus, .vex.vex-theme-wireframe .vex-dialog-form .vex-dialog-input input[type="date"]:focus, .vex.vex-theme-wireframe .vex-dialog-form .vex-dialog-input input[type="datetime"]:focus, .vex.vex-theme-wireframe .vex-dialog-form .vex-dialog-input input[type="datetime-local"]:focus, .vex.vex-theme-wireframe .vex-dialog-form .vex-dialog-input input[type="email"]:focus, .vex.vex-theme-wireframe .vex-dialog-form .vex-dialog-input input[type="month"]:focus, .vex.vex-theme-wireframe .vex-dialog-form .vex-dialog-input input[type="number"]:focus, .vex.vex-theme-wireframe .vex-dialog-form .vex-dialog-input input[type="password"]:focus, .vex.vex-theme-wireframe .vex-dialog-form .vex-dialog-input input[type="search"]:focus, .vex.vex-theme-wireframe .vex-dialog-form .vex-dialog-input input[type="tel"]:focus, .vex.vex-theme-wireframe .vex-dialog-form .vex-dialog-input input[type="text"]:focus, .vex.vex-theme-wireframe .vex-dialog-form .vex-dialog-input input[type="time"]:focus, .vex.vex-theme-wireframe .vex-dialog-form .vex-dialog-input input[type="url"]:focus, .vex.vex-theme-wireframe .vex-dialog-form .vex-dialog-input input[type="week"]:focus {\n        border-style: dashed;\n        outline: none; }\n  .vex.vex-theme-wireframe .vex-dialog-form .vex-dialog-buttons {\n    *zoom: 1; }\n    .vex.vex-theme-wireframe .vex-dialog-form .vex-dialog-buttons:after {\n      content: "";\n      display: table;\n      clear: both; }\n  .vex.vex-theme-wireframe .vex-dialog-button {\n    border-radius: 0;\n    border: 0;\n    float: right;\n    margin: 0 0 0 .5em;\n    font-family: inherit;\n    text-transform: uppercase;\n    letter-spacing: .1em;\n    font-size: .8em;\n    line-height: 1em;\n    padding: .75em 2em; }\n    .vex.vex-theme-wireframe .vex-dialog-button.vex-last {\n      margin-left: 0; }\n    .vex.vex-theme-wireframe .vex-dialog-button:focus {\n      -webkit-animation: vex-pulse 1.1s infinite;\n      animation: vex-pulse 1.1s infinite;\n      outline: none; }\n      @media (max-width: 568px) {\n        .vex.vex-theme-wireframe .vex-dialog-button:focus {\n          -webkit-animation: none;\n          animation: none; } }\n    .vex.vex-theme-wireframe .vex-dialog-button.vex-dialog-button-primary {\n      background: #000;\n      color: #fff;\n      border: 2px solid transparent; }\n    .vex.vex-theme-wireframe .vex-dialog-button.vex-dialog-button-secondary {\n      background: #fff;\n      color: #000;\n      border: 2px solid #000; }\n\n.vex-loading-spinner.vex-theme-wireframe {\n  height: 2.5em;\n  width: 2.5em; }\n',
      '',
    ]);
  },
  function (e, t, n) {
    var o = n(7);
    'string' == typeof o && (o = [[e.i, o, '']]);
    var i = { hmr: !0, transform: void 0, insertInto: void 0 };
    n(2)(o, i);
    o.locals && (e.exports = o.locals);
  },
  function (e, t) {
    e.exports = function (e) {
      var t = 'undefined' != typeof window && window.location;
      if (!t) throw new Error('fixUrls requires window.location');
      if (!e || 'string' != typeof e) return e;
      var n = t.protocol + '//' + t.host,
        o = n + t.pathname.replace(/\/[^\/]*$/, '/');
      return e.replace(
        /url\s*\(((?:[^)(]|\((?:[^)(]+|\([^)(]*\))*\))*)\)/gi,
        function (e, t) {
          var i,
            r = t
              .trim()
              .replace(/^"(.*)"$/, function (e, t) {
                return t;
              })
              .replace(/^'(.*)'$/, function (e, t) {
                return t;
              });
          return /^(#|data:|http:\/\/|https:\/\/|file:\/\/\/|\s*$)/i.test(r)
            ? e
            : ((i =
                0 === r.indexOf('//')
                  ? r
                  : 0 === r.indexOf('/')
                  ? n + r
                  : o + r.replace(/^\.\//, '')),
              'url(' + JSON.stringify(i) + ')');
        }
      );
    };
  },
  function (e, t, n) {
    (e.exports = n(3)(!1)).push([
      e.i,
      '@-webkit-keyframes vex-fadein {\n  0% {\n    opacity: 0; }\n  100% {\n    opacity: 1; } }\n\n@keyframes vex-fadein {\n  0% {\n    opacity: 0; }\n  100% {\n    opacity: 1; } }\n\n@-webkit-keyframes vex-fadeout {\n  0% {\n    opacity: 1; }\n  100% {\n    opacity: 0; } }\n\n@keyframes vex-fadeout {\n  0% {\n    opacity: 1; }\n  100% {\n    opacity: 0; } }\n\n@-webkit-keyframes vex-rotation {\n  0% {\n    -webkit-transform: rotate(0deg);\n    transform: rotate(0deg); }\n  100% {\n    -webkit-transform: rotate(359deg);\n    transform: rotate(359deg); } }\n\n@keyframes vex-rotation {\n  0% {\n    -webkit-transform: rotate(0deg);\n    transform: rotate(0deg); }\n  100% {\n    -webkit-transform: rotate(359deg);\n    transform: rotate(359deg); } }\n\n.vex, .vex *, .vex *:before, .vex *:after {\n  -moz-box-sizing: border-box;\n  box-sizing: border-box; }\n\n.vex {\n  position: fixed;\n  overflow: auto;\n  -webkit-overflow-scrolling: touch;\n  z-index: 1111;\n  top: 0;\n  right: 0;\n  bottom: 0;\n  left: 0; }\n\n.vex-scrollbar-measure {\n  position: absolute;\n  top: -9999px;\n  width: 50px;\n  height: 50px;\n  overflow: scroll; }\n\n.vex-overlay {\n  -webkit-animation: vex-fadein .5s;\n  animation: vex-fadein .5s;\n  position: fixed;\n  z-index: 1111;\n  background: rgba(0, 0, 0, 0.4);\n  top: 0;\n  right: 0;\n  bottom: 0;\n  left: 0; }\n\n.vex-overlay.vex-closing {\n  -webkit-animation: vex-fadeout .5s forwards;\n  animation: vex-fadeout .5s forwards; }\n\n.vex-content {\n  -webkit-animation: vex-fadein .5s;\n  animation: vex-fadein .5s;\n  background: #fff; }\n\n.vex.vex-closing .vex-content {\n  -webkit-animation: vex-fadeout .5s forwards;\n  animation: vex-fadeout .5s forwards; }\n\n.vex-close:before {\n  font-family: Arial, sans-serif;\n  content: "\\D7"; }\n\n.vex-dialog-form {\n  margin: 0; }\n\n.vex-dialog-button {\n  text-rendering: optimizeLegibility;\n  -webkit-appearance: none;\n  -moz-appearance: none;\n  appearance: none;\n  cursor: pointer;\n  -webkit-tap-highlight-color: transparent; }\n\n.vex-loading-spinner {\n  -webkit-animation: vex-rotation .7s linear infinite;\n  animation: vex-rotation .7s linear infinite;\n  box-shadow: 0 0 1em rgba(0, 0, 0, 0.1);\n  position: fixed;\n  z-index: 1112;\n  margin: auto;\n  top: 0;\n  right: 0;\n  bottom: 0;\n  left: 0;\n  height: 2em;\n  width: 2em;\n  background: #fff; }\n\nbody.vex-open {\n  overflow: hidden; }\n',
      '',
    ]);
  },
  function (e, t, n) {
    var o = n(10);
    'string' == typeof o && (o = [[e.i, o, '']]);
    var i = { hmr: !0, transform: void 0, insertInto: void 0 };
    n(2)(o, i);
    o.locals && (e.exports = o.locals);
  },
  function (e, t) {
    (function (t) {
      e.exports = t;
    }.call(this, {}));
  },
  function (e, t) {
    var n,
      o,
      i = (e.exports = {});
    function r() {
      throw new Error('setTimeout has not been defined');
    }
    function a() {
      throw new Error('clearTimeout has not been defined');
    }
    function s(e) {
      if (n === setTimeout) return setTimeout(e, 0);
      if ((n === r || !n) && setTimeout)
        return (n = setTimeout), setTimeout(e, 0);
      try {
        return n(e, 0);
      } catch (t) {
        try {
          return n.call(null, e, 0);
        } catch (t) {
          return n.call(this, e, 0);
        }
      }
    }
    !(function () {
      try {
        n = 'function' == typeof setTimeout ? setTimeout : r;
      } catch (e) {
        n = r;
      }
      try {
        o = 'function' == typeof clearTimeout ? clearTimeout : a;
      } catch (e) {
        o = a;
      }
    })();
    var l,
      c = [],
      u = !1,
      f = -1;
    function d() {
      u &&
        l &&
        ((u = !1), l.length ? (c = l.concat(c)) : (f = -1), c.length && p());
    }
    function p() {
      if (!u) {
        var e = s(d);
        u = !0;
        for (var t = c.length; t; ) {
          for (l = c, c = []; ++f < t; ) l && l[f].run();
          (f = -1), (t = c.length);
        }
        (l = null),
          (u = !1),
          (function (e) {
            if (o === clearTimeout) return clearTimeout(e);
            if ((o === a || !o) && clearTimeout)
              return (o = clearTimeout), clearTimeout(e);
            try {
              o(e);
            } catch (t) {
              try {
                return o.call(null, e);
              } catch (t) {
                return o.call(this, e);
              }
            }
          })(e);
      }
    }
    function h(e, t) {
      (this.fun = e), (this.array = t);
    }
    function v() {}
    (i.nextTick = function (e) {
      var t = new Array(arguments.length - 1);
      if (arguments.length > 1)
        for (var n = 1; n < arguments.length; n++) t[n - 1] = arguments[n];
      c.push(new h(e, t)), 1 !== c.length || u || s(p);
    }),
      (h.prototype.run = function () {
        this.fun.apply(null, this.array);
      }),
      (i.title = 'browser'),
      (i.browser = !0),
      (i.env = {}),
      (i.argv = []),
      (i.version = ''),
      (i.versions = {}),
      (i.on = v),
      (i.addListener = v),
      (i.once = v),
      (i.off = v),
      (i.removeListener = v),
      (i.removeAllListeners = v),
      (i.emit = v),
      (i.prependListener = v),
      (i.prependOnceListener = v),
      (i.listeners = function (e) {
        return [];
      }),
      (i.binding = function (e) {
        throw new Error('process.binding is not supported');
      }),
      (i.cwd = function () {
        return '/';
      }),
      (i.chdir = function (e) {
        throw new Error('process.chdir is not supported');
      }),
      (i.umask = function () {
        return 0;
      });
  },
  function (e, t, n) {
    'use strict';
    n.r(t);
    var o = n(1),
      i = n(0);
    n(11), n(8), n(6);
    (i.defaultOptions.className = 'vex-theme-wireframe'),
      (i.defaultOptions.escapeButtonCloses = !1),
      (i.defaultOptions.overlayClosesOnClick = !1),
      (i.dialog.buttons.YES.text = 'I Understand');
    var r = 'https://haveibeenpwned.com/api/v2/breachedaccount/',
      a = 'https://api.pwnedpasswords.com/range/';
    function s(e, t = 0, n = ',', o = '.') {
      if ((0 !== e && !e) || !Number.isFinite(e)) return e;
      const i = Number.isFinite(t) ? Math.min(Math.max(t, 0), 7) : 0,
        r = e.toFixed(i).toString(),
        a = r.split('.');
      let s = a[0].split('').reverse(),
        l = '';
      r < 0 && (l = s.pop());
      let c = [],
        u = 0;
      for (; s.length > 1; ) c.push(s.shift()), ++u % 3 == 0 && c.push(n);
      return (
        c.push(s.shift()),
        `${l}${c.reverse().join('')}${i > 0 ? o : ''}${
          i > 0 && a[1] ? a[1] : ''
        }`
      );
    }
    function l(e) {
      return 'true' === (sessionStorage.getItem(e) || localStorage.getItem(e));
    }
    function c() {
      for (
        var e = document.getElementsByTagName('input'), t = 0;
        t < e.length;
        t++
      )
        switch (e[t].type) {
          case 'email':
            break;
          case 'password':
            e[t].addEventListener('change', h);
        }
      e = document.querySelectorAll("input[type='text']");
      for (t = 0; t < e.length; t++) {
        if (-1 !== e[t].name.toLowerCase().indexOf('email'))
          return e[t].addEventListener('change', d);
        if (-1 !== e[t].id.toLowerCase().indexOf('email'))
          return e[t].addEventListener('change', d);
        if (-1 !== e[t].placeholder.toLowerCase().indexOf('email'))
          return e[t].addEventListener('change', d);
      }
    }
    function u(e) {
      return o(e + '-' + f());
    }
    function f() {
      return window.location.host.split('.').slice(-2).join('.');
    }
    function d(e) {
      var t = f(),
        n = new XMLHttpRequest(),
        o = e.currentTarget.value;
      (n.onreadystatechange = function () {
        if (4 === n.readyState && 200 === n.status)
          for (var e = JSON.parse(n.responseText), r = 0; r < e.length; r++)
            if (e[r].Domain === t && e[r].IsVerified) {
              var a = [
                '<p>' + e[r].Description + '</p>',
                '<p>The email you entered was one of the <b>' +
                  s(e[r].PwnCount) +
                  "</b> that were compromised. If you haven't done so already, you should change your password.</p>",
              ].join('');
              i.dialog.alert({
                message: 'Breach detected!',
                input: a,
                callback: function () {
                  localStorage.setItem(u(o), 'true');
                },
              });
            }
      }),
        l(u(o)) || (n.open('GET', r + encodeURIComponent(o), !0), n.send(null));
    }
    function p(e) {
      return o(o(e).slice(0, 5) + '-' + f());
    }
    function h(e) {
      var t = e.currentTarget.value,
        n = o(t).toUpperCase(),
        r = n.slice(0, 5),
        c = n.slice(5),
        u = new XMLHttpRequest();
      (u.onreadystatechange = function () {
        if (4 === u.readyState && 200 === u.status)
          for (var e = u.responseText.split('\n'), n = 0; n < e.length; n++) {
            var o = e[n].split(':');
            if (0 === o[0].indexOf(c)) {
              var r = [
                '<p>The password you just entered has been found in <b>' +
                  s(parseInt(o[1])) +
                  '</b> data breaches. <b>This password is not safe to use</b>.</p>',
                '<p>This means attackers can easily find this password online and will often try to access accounts with it.</p>',
                '<p>If you are currently using this password, please change it immediately to protect yourself. For more information, visit <a href="https://haveibeenpwned.com/" title="haveibeenpwned">Have I Been Pwned?</a>',
                '<p>This notice will not show again for the duration of this session to give you time to update this password.</p>',
              ].join('');
              i.dialog.alert({
                message: 'Unsafe password detected!',
                input: r,
                callback: function () {
                  sessionStorage.setItem(p(t), 'true');
                },
              });
            }
          }
      }),
        l(p(t)) || (u.open('GET', a + r, !0), u.send(null));
    }
    if (window.attachEvent) window.attachEvent('onload', c);
    else if (window.onload) {
      var v = window.onload;
      window.onload = function (e) {
        v(e), c();
      };
    } else window.onload = c;
  },
]);
