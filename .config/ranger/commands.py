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

class yank(Command):
    def execute(self):
        if self.rest(1):
            target = self.rest(1)
        else:
            target = self.fm.thisfile.path
        self.fm.run(f"wl-copy < '{target}'", flags='f')
class spread(Command):
    def execute(self):
        if not self.arg(1):
            self.fm.notify("spread: missing filename", bad=True)
            return

        filename = self.rest(1)

        self.fm.run(
            ["sh", "-c", f"wl-paste > {filename}"],
            flags="w"
        )

class kitty(Command):
    def execute(self):
        self.fm.run("kitty &")

# If you're a visual studio code user.
class vsc(Command):
    def execute(self):
        if self.rest(1):
            target = self.rest(1)
        else:
            target = self.fm.thisfile.path
        self.fm.run(f"flatpak run com.visualstudio.code '{target}'", flags='f')

# If you're a nvim user.
class nvim(Command):
    def execute(self):
        if self.rest(1):
            target = self.rest(1)
        else:
            target = self.fm.thisfile.path
        self.fm.run(f"kitty -e nvim '{target}'", flags='f')
