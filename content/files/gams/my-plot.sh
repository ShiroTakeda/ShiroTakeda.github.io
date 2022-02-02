# my-plot.sh

pgnuplot $1 - &
wait $!
exit
