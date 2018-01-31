#!/usr/bin/expect -f

##----------------------------------------------------------------------
##
## Example call of this expect script:
##
##    $ ./r host_ip_number username passphrase remote_command
##
##
## REFERENCES:
##  *  https://debaan.blogspot.com/2007/09/simple-expect-ssh-example.html
##  ...mentioned expect_after {...} construct, and
##
##  *  http://wiki.tcl.tk/17378 . . . set prompt {$ }
##----------------------------------------------------------------------



## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
## - SECTION - store parameters from command line
## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

# treat first argument as remote host IP number, second arg as username there,
# treat argument 3 as pass phrase
# treat argument 4 as command to run on remote host

set es_host [lindex $argv 0]
set es_user [lindex $argv 1]
set es_passphrase [lindex $argv 2]
set es_remote_command [lindex $argv 3]

set es_logfile "./z"



## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
## - SECTION - expect script variables
## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

set timeout 7

set prompt {$ }



puts "expect script starting,"
# puts "-- NOTE -- from caller received remote command:"
# puts $es_remote_command
# puts " "
puts "1) expect script timeout set to $timeout seconds,"
puts "2) variable \$user is string of [string bytelength $es_user],"
puts " "

if {[string bytelength $es_remote_command] < 20} {
    puts "setting remote command string locally,"
    set es_remote_command "ip=`ifconfig | grep inet | grep 10.174 | grep Bcast | awk '{ print \$2 }' | cut -d\":\" -f2`; hn=`hostname`; echo \"\$ip   \$hn\""
}


## spawn ssh $es_user@$es_host $es_remote_command
spawn ssh $es_user@$es_host

expect_after eof { exit 0 }

expect "yes/no" { send "yes\r" }

expect "*ssword: " { send "$es_passphrase\r" }



## - HERE - try to capture result of remote command:

    expect $prompt

    send $es_remote_command\r
    expect "\r"

    puts "-- OPENING LOG FILE -- "
    log_file $es_logfile
#    expect {[0-9]+\.[0-9]+\ \ \ ([a-zA-Z0-9\-])+}
    expect "\r"
    log_file
    puts "-- CLOSING LOG FILE -- "

    puts "-- NOTE -- expecting prompt . . ."
    expect $prompt


puts "expect script done."



## --- EOF ---
