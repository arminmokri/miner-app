#!/usr/bin/expect -f

log_user 0

set address [lindex $argv 0]
set username [lindex $argv 1]
set password [lindex $argv 2]
set cmd [lindex $argv 3]

### start telnet
spawn telnet ${address}

### user
expect "*username:*"
send -- "${username}\r"

### pass
expect "*password:*"
send -- "${password}\r"

### cmd
expect "*TBS>>*"
send -- "${cmd}\r"

### exit
expect "*TBS>>*"
send -- "exit\r"
expect "*Are you sure to logout?*"
send -- "Y\r"

###
expect
exit
