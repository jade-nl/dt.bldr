
# Information about the scripts

## dt.bldr.sh - the main script

This script is what this project is all about and was created to make fetching,
building and installing darktable easier and more flexible.

In essence there is nothing wrong at all with the "git version" instructions on
the darktable website (right here: https://www.darktable.org/install/). But if
you are like me and don't like doing things multiple times by hand, like to test
specific options or build a version specific for your environment, you might
want or need more flexibility.

Checking if all the dependencies are met for building darktable and presenting
them in a nice fashion is out of scope. The script will stop with a nice error
message and all the output generated is put into a log file, so you do have a
starting point to tackle the problem if you run into them. There's also an
option in the config file that creates verbose logging if need be.

The following options can be used when running dt.bldr.sh:

*  **-c**      Clone files from the darktable git repository
*  **-p**      Pull updates from the darktable git repository
*  **-C file** Use file as configuration
*  **-s**      Stop if versions are the same
*  **-b**      Build darktable
*  **-i**      Install darktable
*  **-m**      Merge one external branch using default merge configuration file
*  **-M file** Merge one external branch using specified configuration file
*  **-M URL**  Merge one external branch using specified URL
*  **-t**      Download the integration tests
*  **-h**      Show help

If no options are given when running the script, the defaults that are in the
global configuration file are being used.

The global/default configuration file (*/opt/dt.dt.bldr/cfg/dt.bldr.cfg*) is set
to use *-c* and *-b*. I would recommend to set a sensible combo in the
personalised config file (*$HOME/.local/cfg/dt.bldr.cfg*). I use the following
default set: *-p -s -b -i* (*-psbi*) Do have a look at the example configuration
files present in the examples directory.

The clone and pull options (*-c* and *-p*) will also take care of the rawspeed
module.

The *-C file* option can be used to point dt.bldr.sh to a different
configuration file. When used it will replace the default
~/.local/cfg/dt.bldr.cfg file.
If *-C file* is used *-b* and *-i* will be set forced (*dt.bldr.sh -C file* and
*dt.bldr.sh -biC file* do the same thing).

The *-s* option checks if the latest cloned/pulled git version is the same as
the darktable version that is already installed. If this is the case then the
build and/or install steps are skipped.

If ninja is installed it will _not_ be used out-of-the-box, you need to tell the
script to use it by setting the appropriate option in the local copy of your
dt.bldr.cfg file.

Out-of-the-box the script will use 75% of the cores available, using *make -jX*.
This can also be adjusted in the configuration file. The current allowed range
is 10% -> 200%

In certain situations sudo will be used during the installation of darktable. At
the moment the use of sudo will be triggered by the CMAKE_PREFIX_PATH variable
starting with either of these three, making it a system wide install :

* /opt/
* /usr/
* /bin/

I strongly discourage using /bin as prefix because the installation process
installs more then just a few binaries. These would all end up in /bin when
setting the global prefix to /bin. This can be fine-tuned in the configuration
file though.

The -t option takes care of the integration tests that come with darktable. The
main reason for this script is to be able to build an install one or more
personalized darktable versions and/or relatively easy build and test PRs. As
such these integration tests are out-of-scope.

The integration tests are rather large and are not being downloaded by default.
There's a configuration option that can be set in dt.bldr.cfg to change this
behaviour. 

I decided to make it possible to merge a branch from a forked darktable
repository into the current master. This is done using the -m options and a file
that looks like dt.ext.branch.cfg. This file holds the URL of the forked
repository and the name of the branch to be merged (the example directory has a
sample).

**Beware:** This merge option (*-m/-M <file|URL>*) might not work as intended
depending on the branch that is being merged, the chosen method and/or the
state of darktable's master branch. Especially "old" PRs might introduce
merging issues, the script is not intelligent enough to solve this.

The safest way to merge an external branch is to clone darktable first instead
of pulling. If the *-m* or *-M <file|URL>* option is used and no other options
are given cloning is forced. *-c* and *-p* can be used in conjunction with *-m*
or *-M <file|URL>*.

Cloning darktable has become more and more time consuming, so trying to pull
and merge first is an option. If this fails cloning has to be done, even if it
is decided that the external branch isn't worth it!

When multiple branches need to be integrated you need to merge these one at the
time at the moment. There's no need to build and install for every external
branch, though. Use dt.bldr.sh *-pM file* for each additional branch until all
are merged and then run *dt.bldr.sh -bi* to build and install.

Safest way to integrate external branches:

- **dt.bldr.sh -bim** 
- **dt.bldr.sh -biM /path/to/merge.file.1.cfg**
- **dt.bldr.sh -biM https://valid_url_goes_here**

Either of those three will force cloning darktable, merge an external branch and then build and install darktable.

Add other external branches on top of the previous step by doing either of the following:

- **dt.bldr.sh -pbiM /path/to/merge.file.2.cfg**
- **dt.bldr.sh -pbiM https://valid_url_goes_here**

To get rid of all the merged branches just run *dt.bldr.sh -c*, which will force
a fresh darktable clone.

---
## General

This script will always start with parsing the system-wide configuration file that
can be found in /opt/dt.bldr/cfg and, if present, overlay the local copy. So even if
you use a local configuration file that has a limited amount of entries the
complete set of options is used/shown.
