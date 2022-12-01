set ns [new Simulator] 

set tf [open p2.tr w]
$ns trace-all $tf

set nf [open p2.nam w]
$ns namtrace-all $nf

set cwind [open g.tr w]


set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]

$ns duplex-link $n1 $n3 2Mb 2ms DropTail
$ns duplex-link $n2 $n3 2Mb 2ms DropTail
$ns duplex-link $n3 $n4 2Mb 2ms DropTail
$ns duplex-link $n4 $n5 2Mb 2ms DropTail
$ns duplex-link $n4 $n6 2Mb 2ms DropTail
$ns queue-limit $n1 $n3 10

set tcp [new Agent/TCP]
$ns attach-agent $n1 $tcp

set sink [new Agent/TCPSink]
$ns attach-agent $n6 $sink
$ns connect $tcp $sink

set ftp [new Application/FTP]
$ftp attach-agent $tcp

set tcp1 [new Agent/TCP]
$ns attach-agent $n2 $tcp1

set sink1 [new Agent/TCPSink]
$ns attach-agent $n5 $sink1
$ns connect $tcp1 $sink1

set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1

$ns at 0.5 "$ftp start"
$ns at 1.0 "$ftp1 start"

$ns at 10.0 "finish"

proc plotWindow {tcpSource file} {
global ns 
set time 0.01
set now [$ns now]
set cwnd [$tcpSource set cwnd_]
puts $file "$now $cwnd"
$ns at [expr $now+$time] "plotWindow $tcpSource $file"}
$ns at 2.0 "plotWindow $tcp $cwind"
$ns at 5.5 "plotWindow $tcp1 $cwind"


proc finish {} {
global ns tf nf cwind 
$ns flush-trace
close $tf
close $nf
exec nam p2.nam &
exec xgraph g.tr &
exit 0
}
$ns run