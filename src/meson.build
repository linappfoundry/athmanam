cc = meson.get_compiler('c')
m_dep = cc.find_library('m', required : false)

executable(
    meson.project_name(),
    'AthmanamApp.vala',
    'Widgets/MainWindow.vala',
    'Widgets/PoemParserWebView.vala',
    dependencies: [
        dependency('gtk+-3.0'),
        dependency('glib-2.0'),
        dependency('libsoup-2.4'),
	dependency('webkit2gtk-4.0'),
        dependency('json-glib-1.0'),
        dependency('libxml-2.0'),
        m_dep
    ],
    link_with: [domserver_lib],
    install: true
)

