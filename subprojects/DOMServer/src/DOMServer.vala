use WebKit;

namespace Athmanam.DOMServer {


    [DBus (name = "com.linappfoundry.athmanam.DOMServer")]

    public class DOMServer : Object {

        private WebKit.WebPage page;

        [DBus (visible = false)]
        public void on_bus_aquired(DBusConnection connection) {
            try {
                connection.register_object("/com/linappfoundry/athmanam/domserver", this);
            } catch (IOError error) {
                warning("Could not register service: %s", error.message);
            }
        }

        [DBus (visible = false)]
        public void on_page_created(WebKit.WebExtension extension, WebKit.WebPage page) {
            this.page = page;
        }
    }

    [DBus (name = "com.linappfoundry.athmanam.DOMServer")]
    public errordomain DOMServerError {
        ERROR
    }

    [CCode (cname = "G_MODULE_EXPORT webkit_web_extension_initialize", instance_pos = -1)]
    void webkit_web_extension_initialize(WebKit.WebExtension extension) {

        DOMServer server = new DOMServer();
        extension.page_created.connect(server.on_page_created);
        Bus.own_name(BusType.SESSION, "com.linappfoundry.athmanam.DOMServer", BusNameOwnerFlags.NONE,
            server.on_bus_aquired, null, () => { warning("Could not aquire name"); });

    }

}



