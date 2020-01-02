project('com.linappfoundry.athmanam.DOMServer', ['c', 'vala'])

domserver_lib = shared_library(
    'com.linappfoundry.athmanam.DOMServer',
    'src/DOMServer.vala',
    dependencies: [
        dependency('glib-2.0'),
        dependency('gtk+-3.0'),
        dependency('libsoup-2.4'),
        dependency('webkit2gtk-web-extension-4.0')
    ],
    install: true
)
