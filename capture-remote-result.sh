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
## - SECTION - Tcl procedures
## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

proc show_diag_tcl {caller message options} {
    puts "$caller:  $message"
}


proc token_count {caller tokens} {
    puts "caller '$caller' sends string '$tokens' of [llength $tokens]"
}


proc set_expect_out_pattern_matches {} {
    puts "tcl procedure:  setting expect_out pattern match strings to some values,"

    set expect_out(1,string) 101
    set expect_out(2,string) 102
    set expect_out(3,string) 103
    set expect_out(4,string) 104
    set expect_out(5,string) 105

    set expect_out(6,string) 106
    set expect_out(7,string) 107
    set expect_out(8,string) 108
    set expect_out(9,string) 109

    puts "tcl procedure:  returning to caller . . ."
}



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

set ls_command "ls -f -d \[abcDM\]*\r"



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
## puts "3)"; puts [token_count main "ye to des hai tera"]"
# set a [token_count main "ye to des hai tera"]
## puts "3) zzz $a zzz"
# set b "3) zzz $a zzz"
# puts $b
puts " "


if {[string bytelength $es_remote_command] < 20} {
    puts "setting remote command string locally,"
    set es_remote_command "ip=`ifconfig | grep inet | grep 10.174 | grep Bcast | awk '{ print \$2 }' | cut -d\":\" -f2`; hn=`hostname`; echo \"\$ip   \$hn\""
}


set_expect_out_pattern_matches 
# Hmm, those variables in the tcl procedure only held their non-null values in that scope - TMH

if { 1 } {
    set expect_out(1,string) 101
    set expect_out(2,string) 102
    set expect_out(3,string) 103
    set expect_out(4,string) 104
    set expect_out(5,string) 105

    set expect_out(6,string) 106
    set expect_out(7,string) 107
    set expect_out(8,string) 108
    set expect_out(9,string) 109
}


## spawn ssh $es_user@$es_host $es_remote_command
spawn ssh $es_user@$es_host

expect_after eof { exit 0 }

expect "yes/no" { send "yes\r" }

expect "*ssword: " { send "$es_passphrase\r" }



## - HERE - try to capture result of remote command:

    expect $prompt

    send "$es_remote_command\r"
    expect "\r"


    puts "-- OPENING LOG FILE -- "
    log_file $es_logfile

#    expect "\r"
    expect "_1"

    log_file
    puts "-- CLOSING LOG FILE -- "



    puts "-- NOTE 1 -- expecting prompt . . ."
    expect $prompt


if { 1 } {

    puts "this expect script going on with further tests,"

    puts "- NOTE 2 - to remote host $es_host sending 'ls' with carriage return . . ."
    send "ls -f -d \[abcDM\]*\r"
    expect {
#        -re "(.*)xml" { puts [show_diag_tcl main "expecting \".*xml\", got:" 0]; puts [show_diag_tcl main $expect_out(buffer) 0] }
#        -re "(.*)xml(.*)xml(.*)xml(.*)(.*)(.*)" { puts "- NOTE 2 - characters stored in expect's variable expect_out(1,string) are:"; puts $expect_out(1,string) }
        "\r" { puts "matched a new-line after sending `ls` command,"; exp_continue }
        -re "(.*)bin(.*)Desktop(.*)" { puts "matched pattern to break up remote `ls` results:"; puts $expect_out(1,string); puts $expect_out(2,string); exp_continue }
        -re "(.*)Music\r" { puts "matched pattern ending line with string '(.*)Music'," }
    }

    send $ls_command
    expect -re "(.*)bin(.*)Desktop(.*)"
    puts "- NOTE 3 - splitting ls results on 'bin' and 'Desktop', \$expect_out(buffer) holds:"
    puts "zzz out(buffer)"
    puts $expect_out(buffer)
    puts "zzz out(1,string)"
    puts $expect_out(1,string)
    puts "zzz out(2,string)"
    puts $expect_out(2,string)
    puts "zzz out(3,string)"
    puts $expect_out(3,string)

    send $ls_command
    expect -re "(.*)Music\r"
    puts "- NOTE 4 - looking at expect_out(n,string) for n in 1..3:"
    puts "zzz out(buffer)"
    puts $expect_out(buffer)
    puts "zzz out(1,string)"
    puts $expect_out(1,string)
    puts "zzz out(2,string)"
    puts $expect_out(2,string)
    puts "zzz out(3,string)"
    puts $expect_out(3,string)

    send "\r"
    expect $prompt


    puts "done with extra tests,"
} else {
    puts "expect 'capture result' script skipping extra tests,"
}



puts "expect script done."



## --- EOF ---
