project('com.linappfoundry.athmanam', ['c', 'vala'])

domserver_proj = subproject('DOMServer')
domserver_lib = domserver_proj.get_variable('domserver_lib')

subdir('src')

meson.add_install_script('meson/post_install.py')
