#!/bin/bash

#  dt.cfg.sh.v1.0.0-alpha

# default cfg : /opt/dt.bldr/cfg/dt.bldr.cfg
# user cfg    : /home/druuna/.config/dt.bldr/dt.bldr.cfg

# optsDIRS
# optsCMAKE
# optsUSE
# optsBUILD
# optsDFLT
# optsCRS


awk '
BEGIN { 
  # set field separator
  FS = "[ =]"
  # read /opt/dt.bldr/cfg/dt.bldr.cfg, store relevant parts
  while ( ( getline < "/opt/dt.bldr/cfg/dt.bldr.cfg" ) > 0 )
    { gsub("\"","") 
      if ( $1 ~ /Dir/ )     optsDIRS[$1]  = " D "$2 
      if ( $1 ~ /^CMAKE_/ ) optsCMAKE[$1] = " D "$2  
      if ( $1 ~ /USE_/ )    optsUSE[$1]   = " D "$2  
      if ( $1 ~ /BUILD_/ )  optsBUILD[$1] = " D "$2  
      if ( $1 ~ /_BUILD/ )  optsBUILD[$1] = " D "$2  
      if ( $1 ~ /CUSTOM_/ ) optsBUILD[$1] = " D "$2  
      if ( $1 ~ /^dflt/ )   optsDFLT[$1]  = " D "$2  
      if ( $1 ~ /^crs/ )    optsCRS[$1]   = " D "$2 }
}
{
  # replace default with user entries
    { gsub("\"","") }
    { if ( $1 ~ /Dir/ )     optsDIRS[$1]  = " U "$2 }
    { if ( $1 ~ /^CMAKE_/ ) optsCMAKE[$1] = " U "$2 }
    { if ( $1 ~ /USE_/ )    optsUSE[$1]   = " U "$2 }
    { if ( $1 ~ /BUILD_/ )  optsBUILD[$1] = " U "$2 }
    { if ( $1 ~ /_BUILD/ )  optsBUILD[$1] = " U "$2 }
    { if ( $1 ~ /CUSTOM_/ ) optsBUILD[$1] = " U "$2 }
    { if ( $1 ~ /^dflt/ )   optsDFLT[$1]  = " U "$2 }
    { if ( $1 ~ /^crs/ )    optsCRS[$1]   = " U "$2 }
}
END {
 { printf "%-25s %3s %s\n", "Option", "D/U", "Value" }
 { print " - directories -" }
 for (key in optsDIRS)  { printf "%-25s %s\n", key, optsDIRS[key] }
 { print " - cmake options -" }
 for (key in optsCMAKE) { printf "%-25s %s\n", key, optsCMAKE[key] }
 { print " - use options -" }
 for (key in optsUSE)   { printf "%-25s %s\n", key, optsUSE[key] }
 { print " - build options -" }
 for (key in optsBUILD) { printf "%-25s %s\n", key, optsBUILD[key] }
 { print " - run options -" }
 for (key in optsDFLT)  { printf "%-25s %s\n", key, optsDFLT[key] }
 { print " - cpu cores -" }
 for (key in optsCRS)   { printf "%-25s %s\n", key, optsCRS[key] }
}' /home/druuna/.config/dt.bldr/dt.bldr.cfg

exit 0

