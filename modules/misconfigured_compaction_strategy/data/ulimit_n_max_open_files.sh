ulimit -n

cat /proc/${PID}/limits | grep "Max open files"