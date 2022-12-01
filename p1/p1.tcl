set ns [new Simulator] 

set tf [open p1.tr w]
$ns trace-all $tf

set nf [open p1.nam w]
$ns namtrace-all $nf

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

$ns duplex-link $n0 $n2 2Mb 2ms DropTail
$ns duplex-link $n1 $n2 2Mb 2ms DropTail
$ns duplex-link $n2 $n3 4Mb 2ms DropTail
$ns queue-limit $n0 $n2 5

set tcp1 [new Agent/TCP]
$ns attach-agent $n0 $tcp1

set sink0 [new Agent/TCPSink]
$ns attach-agent $n3 $sink0

$ns connect $tcp1 $sink0

set ftp [new Application/FTP]
$ftp attach-agent $tcp1

set udp1 [new Agent/UDP]
$ns attach-agent $n1 $udp1

set null1 [new Agent/Null]
$ns attach-agent $n3 $null1

$ns connect $udp1 $null1

set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp1

$ns at 0.5 "$ftp start"
$ns at 1.5 "$cbr1 start"
$ns at 10.0 "finish"

proc finish {} {
global ns tf nf 
$ns flush-trace
close $tf
close $nf
exec nam p1.nam &
exit 0
}
$ns run

