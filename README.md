## dt.bldr

This project was initially created to automate the darktable cloning, building and installing process.

The first script was never put on-line, it worked but wasn't flexible enough and became bloated with stuff that wasn't part of the core idea. This version is back to its leaner form and hopefully flexible enough for future ideas.

Being able to keep using the default, stable darktable that comes with your Linux distro and test or play with an up-to-date development version has always been the starting point when I started building the main script.

Although multiple darktable's can be run with the --configdir option I prefer to separate the two versions even more by using two different users. This is less prone to ending up with a user environment that is only accessible by the newest, possibly unstable version.

The main script ***does not*** handle the above mentioned separation! Assuming that you want to run multiple darktable versions; It is up to you to set this up the way you like it.

In its simplest form *dt.bldr.sh* will keep things local, everything will be placed in ~/.local to be precise. Have a good look at the configuration options and the README files before running the main script.

### The scripts

The main script, *dt.bldr.sh*, can be used to clone, pull, build and install darktable. Each action can be done separately, all at once or in some combination.

A companion script, *dt.cfg.sh*, can be used to check the configuration file(s) or show some relevant information.

After fetching this repo you can use the *installer.sh* script to put all the files and directories in their intended place: *sudo sh install.sh* There is also a very simple *uninstall.sh* script present in the bin directory.

### 1st time running dt.bldr.sh

Before you run dt.bldr.sh for the first time please read the README files.

All the scripts should be run as a normal user, except the install.sh script which needs sudo.

To get an idea of the options and settings you might want to run *dt.bldr.sh -h* first.

If a system wide installation of darktable is what you are after then it is safe to copy *examples/dt.bldr.cfg.system.wide* to *~/.local/cfg* and rename it to *dt.bldr.cfg*.

The dt.bldr.cfg.system.wide configuration file is based on the settings used by the darktable development team when using their *build.sh* script. The only exception being the *CMAKE_BUILD_TYPE* setting, which is changed from *RelWithDebInfo* to *Release*.

The other options in the dt.bldr.cfg.system.wide file have settings that should be sane/safe.

Run *dt.cfg.sh* to check and get an overview of the options.

Run *dt.cfg.sh -s* to see all the options and some darktable/build related information.

Don't rely on the default run option the first time you use *dt.bldr.sh*. Use these following commands one at the time to make sure all is well:

```
dt.bldr.sh -c    # first time run, clone darktable
dt.bldr.sh -b    # build darktable
dt.bldr.sh -i    # if all looks good, install darktable
```

If the above steps went as expected you can now safely run *dt.bldr.sh* without any options and thus fall back to the default run options that you set in the configuration file.

### TODO

The current version works and can be used 'as-is', but there are some things I like to add or change to either of the scripts. Not sure if it is going to happen, but maybe if I mention the two I'm mostly thinking about I am more inclined to actually start working on them.

- [ ] Make it possible to build darktable against the newest, locally build, applications.
- [ ] Remove or overhaul dt.cfg.sh's -s option.

### Useful sources

- [darktable website](https://www.darktable.org/)
- [darktable on GitHub](https://github.com/darktable-org/darktable)
- [Building darktable](https://redmine.darktable.org/projects/darktable/wiki/Building_darktable_20)
