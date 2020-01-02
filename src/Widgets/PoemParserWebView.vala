
public class PoemParserWebView : WebKit.WebView {

    public signal void poem_loaded(string result);
    private string poemUrl = "";

    private const string JAVASCRIPT = """
        var elems = document.getElementsByClassName("o-poem");
        var poem = "";

        /*var limit = 1001;
        for(var i=1;i<=limit;i++) {
            if(i!=limit) {
                poem = poem + "a";
            }else{
                poem = poem + "l";
            }

        }
        poem = window.btoa(poem);*/

        if(elems.length > 0) {
            poem = document.getElementsByClassName("o-poem")[0].innerText.replace(/(\r\n|\n|\r)/gm,"|");
            //poem = document.getElementsByClassName("o-poem")[0].innerText;
            poem = window.btoa(unescape(encodeURIComponent(poem)));
            document.title = poem;

        }else{
            var image = document.querySelector(".c-assetStack-media img");
            document.title = "{1}" + image.src;
        }

        """;


    public PoemParserWebView() {
        //GLib.print("\n PoemParserWebView Constructed");

        WebKit.Settings webkitSettings = new WebKit.Settings();
        webkitSettings.enable_developer_extras = true;
        webkitSettings.allow_file_access_from_file_urls = true;

        this.set_settings(webkitSettings);

        this.load_changed.connect(on_load_changed);
        //this.set_no_show_all(true);
    }


    public void loadPage(string url = "") {

        GLib.print("\n PoemParserWebView loadPage");
        if(url != "") {
            this.poemUrl = url;
        }

        load_uri(this.poemUrl);
    }


    public void setPoemUrl(string url) {
        this.poemUrl = url;
    }

    private void on_title_changed(ParamSpec p) {
        GLib.print("\n on_title_changed");
        notify["title"].disconnect(on_title_changed);
        GLib.print(title);
        poem_loaded(title);
    }

    public void on_load_changed(WebKit.LoadEvent load_event) {

        switch(load_event) {
            case WebKit.LoadEvent.STARTED:
				GLib.print("\n on_load_changed ::: Load Started");
				break;
			case WebKit.LoadEvent.REDIRECTED:
				GLib.print("\n on_load_changed ::: Load Redirected");
				break;
			case WebKit.LoadEvent.COMMITTED:
				GLib.print("\n on_load_changed ::: Load Committed");
				break;
			case WebKit.LoadEvent.FINISHED:
			    notify["title"].connect(on_title_changed);
                run_javascript.begin(JAVASCRIPT, null);
				GLib.print("\n on_load_changed ::: Load Finished");
				break;

        }
    }



}