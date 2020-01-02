using Soup;
using Gtk;

class AthmanamApp : Gtk.Application {

    protected override void activate() {
       MainWindow window = new MainWindow(this);
       window.resize(500, 600);
       window.show_all();
       //window.show_all.connect
       window.loadPoetry();
    }


    public static int main(string[] args) {
        return new AthmanamApp().run(args);
    }

}
