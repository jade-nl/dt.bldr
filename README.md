## Version 2.0.0 was just released. Please have a look at the [release notes](https://github.com/jade-nl/dt.bldr/releases/tag/v2.0.0)

## dt.bldr

**A linux based darktable builder and installer. The source can be either the
development git version or a stable version via local tarball.**

This project was initially created to automate the darktable clone (or pull),
configure, build and install process.

The first script was never put on-line, it worked but wasn't flexible enough and
became bloated with stuff that wasn't part of the core idea. This version is
back to its leaner form and hopefully flexible enough for future ideas.

Being able to keep using the default, stable darktable that comes with your
Linux distro and test or play with an up-to-date development version has always
been the starting point when I started building the main script. Out-of-the-box
this script will build and install locally.

Although multiple darktable's can be run with the --configdir option I prefer to
separate the two versions even more by using two different users. This is less
prone to ending up with a user environment that is only accessible by the
newest, possibly unstable version.

The main script ***does not*** handle the above mentioned separation! Assuming
that you want to run multiple darktable versions; It is up to you to set this up
the way you like it. My personal preference is setting up functions and/or
aliases to run the different versions.

In its simplest form *dt.bldr.sh* will keep things local, everything will be
placed in ~/.local to be precise. Have a good look at the configuration options
and the README files before running the main script.

### The scripts

The main script, *dt.bldr.sh*, can be used to clone, pull, build and install
darktable. Each action can be done separately, all at once or in some
combination. There's also an option to integrate one single outside branch,
which can be used to check a bug fix that is still part of their personal
repository.

A companion script, *dt.cfg.sh*, can be used to check the configuration file(s)
or show some relevant information. This script is also run automatically when
the main script is used.

After fetching this repo you can use the *installer.sh* script to put all the
files and directories in their intended place: *sudo sh install.sh* There is
also a very simple *uninstall.sh* script present in the bin directory.

### 1st time running dt.bldr.sh

Before you run dt.bldr.sh for the first time please read the README files and
have a look at the provided configuration files in *examples*

All the scripts should always be run as a normal user. The sudo command will be
used in two situations: manually when executing the install.sh script or,
automatically, when installing darktable system wide instead of locally.

To get an idea of the options and settings you might want to run *dt.bldr.sh -h*
first.

If a system wide installation of darktable is what you are after then it is safe
to copy *examples/dt.bldr.cfg.system.wide* to *~/.local/cfg* and rename it to
*dt.bldr.cfg*.

The dt.bldr.cfg.system.wide configuration file is based on the settings used by
the darktable development team when using their *build.sh* script. The only
exception being the *CMAKE_BUILD_TYPE* setting, which is changed from
*RelWithDebInfo* to *Release*.

The other options in the dt.bldr.cfg.system.wide file have settings that should
be sane/safe. You can change these to your liking.

Run *dt.cfg.sh -h* to check and get an overview of the options.

Run *dt.cfg.sh -s* to see all the options and some darktable/build related
information.

Do not rely on the default run option the first time you use *dt.bldr.sh*. Use
the following commands one at the time to make sure all is well:

```
dt.bldr.sh -c    # first time run, clone darktable
dt.bldr.sh -b    # build darktable
dt.bldr.sh -i    # if all looks good, install darktable
```

If the above steps went as expected you can now safely run *dt.bldr.sh* without
any options and thus fall back to the default run options that you set in the
configuration file.

### Useful sources

- [darktable website](https://www.darktable.org/)
- [darktable on GitHub](https://github.com/darktable-org/darktable)
- [Building darktable](https://github.com/darktable-org/darktable#building)
