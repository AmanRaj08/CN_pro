BEGIN {
count1=0;
count2=0;
}
{
if($1=="d" && $5== "tcp")
count1++;
if($1=="d" && $5== "cbr")
count2++;
}
END{
printf("Number of packet dropped in TCP %d\n", count1);
printf("Number of packet dropped in UDP %d\n", count2);
}
