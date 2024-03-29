# Setup Instructions

1. Install [nix](https://nixos.org/explore). The best way to do this if you don't already have nix installed is via the [Determinate Nix installer](https://github.com/DeterminateSystems/nix-installer). If you are on macOS, you can do this without even going into Terminal.app, with the [Graphical Nix Installer](https://determinate.systems/posts/graphical-nix-installer).
2. Clone this repository with `git clone https://github.com/LocalCharts/forest`, or if you have an SSH key on github, `git clone git@github.com:LocalCharts/forest`.
3. Move into the directory you cloned into with `cd forest`
4. Run `nix develop`. This step might take a while the first time as it installs OCaml, TeXlive, and the automatically refreshing preview server. If this doesn't work, then try `nix develop '.#shell-minimal'`, which only contains forester and the `new` and `build` wrapper commands. Note that in this case you must have a recent TeXlive installation on your computer.
5. If you ran `nix develop` before, then run `forester-dev`. This will start a server at `http://localhost:8080` which serves the built version of the forest. Note that if you go to `http://localhost:8080` you will get a blank screen; you have to go to `http://localhost:8080/index.xml` to get the main page, or `http://localhost:8080/namespace-XXXX.xml` for looking at other pages. Otherwise, if you ran `nix develop '.#shell-minimal'`, you can just run `build` to build the site into the `output/` directory, and then run `serve` to start up a server to preview the output; you can then go to `http://localhost:8080/index.xml` as in the previous instructions.
6. Edit some files in the `trees/` directory! For a reference on forester syntax, see [The Forester markup language](http://www.jonmsterling.com/jms-007N.xml).

# Tips 

If you want to transclude simply the raw content of a tree, do this:

```latex
\scope{
  \put\transclude/heading{false}
  \transclude{. . .}
}
```

Keep an eye out for how [this issue](https://lists.sr.ht/~jonsterling/forester-discuss/%3CCZTDHPB6SZX9.2R4NNQPWGTP5C%40gmail.com%3E) resolves so that this can be done with a convenient macro.