using Gtk;
using WebKit;
using FileUtils;
using GLib;
using Xml;
using Html;


class MainWindow : Gtk.ApplicationWindow {

       private WebView view = null;
       private PoemParserWebView poemParserWebView = null;
       private Gtk.Box box = new Gtk.Box(Gtk.Orientation.VERTICAL, 6);

       private string currentPoemTitle = "";
       private string currentPoemAuthor = "";
       private string currentDir = "";

       public MainWindow (AthmanamApp app) {

            Object (application: app);
            this.title = "Athmanam - Random Poetry Application";
            this.window_position = WindowPosition.CENTER;

            this.destroy.connect(Gtk.main_quit);

            Gtk.HeaderBar headerbar = new Gtk.HeaderBar();
            headerbar.show_close_button = true;
            headerbar.title = "Athmanam - Random Poetry";
            this.set_titlebar(headerbar);

            Gtk.Button refreshButton = new Gtk.Button.with_label ("Refresh");
            refreshButton.clicked.connect(onRefreshButtonClicked);
            headerbar.pack_end(refreshButton);
            //this.set_titlebar(headerbar);

            box = new Gtk.Box(Gtk.Orientation.VERTICAL, 6);

            WebKit.Settings webkitSettings = new WebKit.Settings();
            webkitSettings.enable_developer_extras = true;
            webkitSettings.allow_file_access_from_file_urls = true;

            view = new WebView();
            view.set_settings(webkitSettings);

            poemParserWebView = new PoemParserWebView();
            poemParserWebView.poem_loaded.connect(onPoemLoaded);
            //poemParserWebView.set_visible(false);
            box.pack_end(poemParserWebView);

            box.pack_start(view);
            this.add(box);

            currentDir = GLib.Environment.get_current_dir();
            var file_path = "file://" + currentDir +  "/.linappfoundry/athmanam/html/index.html";
            view.load_uri(file_path);

       }

       public void loadPoetry() {

            int totalPages = 2259;
            var randomPage = Random.int_range(1, totalPages);
            var randomPageStr = randomPage.to_string();
            print("\nRandom Page :::: " + randomPageStr);

            string url = "https://www.poetryfoundation.org/ajax/poems?page=" + randomPageStr + "&sort_by=recently_added";
            print("\nurl:::: " + url);

            var session = new Soup.Session();
            var message = new Soup.Message("GET", url);

            session.queue_message (message, (sess, mess) => {

                var responseBody = (string) mess.response_body.data;
                Json.Parser jsonParser = new Json.Parser();

                try {
                    jsonParser.load_from_data(responseBody);
                } catch (GLib.Error e) {
		            print (e.message);
	            }

                Json.Node node = jsonParser.get_root ();
                Json.Reader reader = new Json.Reader (node);

                bool areEntriesPresent = reader.read_member("Entries");

                if(areEntriesPresent == true){

                    var totalEntries = reader.count_elements();
                    var randomPoemInPage = Random.int_range(0, totalEntries - 1);
                    reader.read_element (randomPoemInPage);

                     /*
                     "title": "The Birth of Shorty Bon Bon (Take #3)",
                     "author": "By Willie Perdomo",
                     "snippet": "The salseros, the real-live soneros,",
                     "link": "https://www.poetryfoundation.org/poems/151850/the-birth-of-shorty-bon-bon-take-3",
                     */

                    reader.read_member("title");
                    currentPoemTitle = reader.get_string_value();
                    reader.end_member();

                    reader.read_member("author");
                    currentPoemAuthor = reader.get_string_value();
                    reader.end_member();

                    reader.read_member("link");
                    var poemLink = reader.get_string_value();
                    reader.end_member();

                    GLib.print("\n:::::Poem Link : " + poemLink);
                    poemLink = "https://www.poetryfoundation.org/poems/52911/the-story-of-light";
                    poemParserWebView.loadPage(poemLink);

                }
            });

       }

       public void on_activate() {
           this.loadPoetry();
       }

       private void onRefreshButtonClicked() {

            view.run_javascript.begin("showLoader();", null);

            this.loadPoetry();
       }

       private void onPoemLoaded(string res) {

          string[] resArr =  res.split("{1}");

          GLib.print("\n:::::" + res);
          GLib.print("\n:::::" + resArr.length.to_string());

          if(resArr.length > 1) {

              var scriptToCallSetPoemImage = """
                   setPoemImage("%s","%s","%s");
              """;
              view.run_javascript.begin(scriptToCallSetPoemImage.printf(resArr[1],currentPoemTitle, currentPoemAuthor), null);

          }else {

             GLib.print("\n:::::" + res.length.to_string());
             var scriptToCallSetPoem = """
                   setPoem("%s","%s","%s");
             """;
             view.run_javascript.begin(scriptToCallSetPoem.printf(res, currentPoemTitle, currentPoemAuthor), null);
          }

       }

 }