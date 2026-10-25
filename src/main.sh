#!/bin/sh

# lfetch: lazyfetch

# store ids
if [ -f /etc/os-release ]; then
    . /etc/os-release
fi

# logos
if [ "$ID" = "alpine" ]; then
logo='                        
       ++++++++++++++++       
      ++++++++++++++++++      
     ++++++++++++++++++++     
    ++++++++++++++++++++++    
   ++++++++   ++++ ++++++++   
  +++++++            +++++++  
 ++++++    +++    +   +++++++
 ++++    + +++++   ++   +++++
  +++  +++ +++++++  ++   +++  
   ++++++++++++++++++++++++   
    ++++++++++++++++++++++    
     ++++++++++++++++++++     
      ++++++++++++++++++
       ++++++++++++++++       
                              
'
fi

if [ "$ID" = "kiss" ]; then
    logo='
|/
|\ISS
'
fi

if [ "$ID" = "arch" ]; then
    logo="                              
              ++              
              ++              
             ++++             
             +++++            
           ++++++++           
          ++++++++++
         ++++++-+++++         
        +++++    +++++        
       ++++++    ++++++       
      +++++        +++++      
     ++                ++     
                              
"
fi

if [ "$ID" = "debian" ]; then
logo='
                       ##                  
                   ##############
                 ####          ####
                ###              ###
               ##        ####     ##
               #       #          ##
               #       #          #
               #       #         ##
               #        #       #
               ##        # ###
                ##
                 ##
                  ## 
                    ##
                        #'
fi

# package logic
if [ "$ID" = "alpine" ]; then
    pkgs=$(apk info -q | wc -l)
fi

if [ "$ID" = "arch" ]; then
    pkgs=$(pacman -Q | wc -l)
fi

if [ "$ID" = "kiss" ]; then
    pkgs=$(kiss list | wc -l)
fi

if [ "$ID" = "debian" ]; then
    pkgs=$(dpkg -l | grep '^ii' | wc -l)
fi

# variables
utime=$(awk '{printf "%d mins\n", $1 / 60}' /proc/uptime)
cpu=$(grep "model name" /proc/cpuinfo | head -n 1 | cut -d':' -f2 | xargs)
os=$(grep "PRETTY_NAME" /etc/os-release | cut -d'"' -f2)
host=$(cat /etc/hostname)
user=$(whoami)
ram=$(awk '/MemTotal|MemFree|Buffers|Cached/{a[$1]=$2} END{printf "%dMB / %dMB\n", (a["MemTotal:"]-a["MemFree:"]-a["Buffers:"]-a["Cached:"])/1024, a["MemTotal:"]/1024}' /proc/meminfo)

# padding / logo output
awk -v logo="$logo" '
BEGIN { n = split(logo, l, "\n") }
{ i[++c] = $0 }
END {
    max = (n > c) ? n : c
    for (j = 1; j <= max; j++)
        printf "%-35s   %s\n", (j in l ? l[j] : ""), (j in i ? i[j] : "")
}' <<EOF



os: $os
host: $host
user: $user
uptime: $utime
cpu: $cpu
ram: $ram
pkgs: $pkgs
EOF
