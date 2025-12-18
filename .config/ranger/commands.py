from ranger.api.commands import Command

class pinta(Command):
    def execute(self):
        if self.rest(1):
            target = self.rest(1)
        else:
            target = self.fm.thisfile.path

        self.fm.run(f"flatpak run com.github.PintaProject.Pinta '{target}'", flags='f')

class vlc(Command):
    def execute(self):
        if self.rest(1):
            target = self.rest(1)
        else:
            target = self.fm.thisfile.path
            
        self.fm.run(f"flatpak run org.videolan.VLC '{target}'", flags='f')

class imgview(Command):
    def execute(self):
        if self.rest(1):
            target = self.rest(1)
        else:
            target = self.fm.thisfile.path
            
        self.fm.run(f"flatpak run org.gnome.Loupe '{target}'", flags='f')

class yank(Command):
    def execute(self):
        if self.rest(1):
            target = self.rest(1)
        else:
            target = self.fm.thisfile.path

        self.fm.run(f"wl-copy < '{target}'", flags='f')

class terminal(Command):
    def execute(self):
        self.fm.run("kitty &")
