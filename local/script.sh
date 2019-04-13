#!/bin/bash
wget -O allPolls 127.0.0.1:8000/polls
rm -rf Poll
mkdir Poll
rm list.html
IP=($(sed -n 's/.*href="\([^"]*\).*/\1/p' allPolls))
echo "<html>" >> list.html
for each in "${IP[@]}"
do
  if [[ ${each:0:3} == "/po" ]] ; then
    ST=${each:7}
    ST=${ST%?}
    echo $ST
    wget -O $ST.html 127.0.0.1:8000$each
    echo "<a href=\"Poll/$ST.html\">POLL $ST</a>" >> list.html
    echo "<br>" >> list.html
    mv $ST.html Poll/
  fi
done
echo "</html>" >> list.html
rm allPolls