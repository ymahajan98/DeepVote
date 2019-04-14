#!/bin/bash
wget -O allFaculty 127.0.0.1:8000/getfaculty

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
      Question=$(grep -o '<h1>.*</h1>' $ST.html | sed 's/\(<h1>\|<\/h1>\)//g')
      Answers=$(grep -o '<label.*>.*</label>' $ST.html )
      Answers=($(echo $Answers | sed 's/<\/\?[^>]\+>//g'))
      rm $ST.html
      echo "<html>" >> $ST.html
      echo "<style>input[type=text], select {  width: 100%;padding: 12px 20px;margin: 8px 0;display: inline-block;border: 1px solid #ccc;border-radius: 4px;box-sizing: border-box;}input[type=submit] {width: 100%;background-color: #4CAF50;color: white;padding: 14px 20px;  margin: 8px 0; border: none;border-radius: 4px;cursor: pointer;}input[type=submit]:hover {background-color: #45a049;}div {border-radius: 5px;background-color: #f2f2f2;padding: 20px;}</style><body><div>" >> $ST.html
      echo "<form action=\"../sign.php\" method=\"post\">" >> $ST.html
      echo "<fieldset><legend>$Question</legend>" >> $ST.html
      i=0
      for option in "${Answers[@]}" ; do
          echo "<input type=\"radio\" value=\"$i\" name=\"vote\"><label>$option</label>" >> $ST.html
          echo "<br>" >> $ST.html
          i=$(($i+1))
      done
      echo "</fieldset>" >> $ST.html
      echo "<input type=\"text\" name=\"pollno\" value=\"$ST\" readonly hidden>" >>$ST.html
      echo "<input type=\"submit\" value=\"Vote\">" >> $ST.html
      echo "</form>" >> $ST.html
      echo "<form action=\"../reveal.php\" method=\"post\">" >> $ST.html
      echo "<input type=\"text\" name=\"pollno\" value=\"$ST\" readonly hidden>" >>$ST.html
      echo "<input type=\"submit\" value=\"Reveal\">" >> $ST.html
      echo "</form></div></body>" >> $ST.html

      echo "<a href=\"Poll/$ST.html\">$Question</a>" >> list.html
      echo "<br>" >> list.html
      echo "</html>" >> $ST.html
      mv $ST.html Poll/
    fi
done
echo "</html>" >> list.html
rm allPolls

# wget -O allReveals 127.0.0.1:8000/reveal
# rm -rf Reveal 
# mkdir Reveal 
# rm listR.html
# IP=($(sed -n 's/.*href="\([^"]*\).*/\1/p' allReveals))
# echo "<html>" >> listR.html
# for each in "${IP[@]}"
# do
#     if [[ ${each:0:3} == "/re" ]] ; then
#       ST=${each:7}
#       ST=${ST%?}
#       echo $ST
#       wget -O $ST.html 127.0.0.1:8000$each
#       Question=$(grep -o '<h1>.*</h1>' $ST.html | sed 's/\(<h1>\|<\/h1>\)//g')
#       Answers=$(head -n 1 ${ST}vote.html)
#       rm $ST.html
#       echo "<html>" >> $ST.html
#       echo "<form action=\"../reveal.php\" method=\"post\">" >> $ST.html
#       echo "<fieldset><legend>$Question</legend>" >> $ST.html
#       echo "<h1>$Answers</h1>" >>$ST.html
#       echo "</fieldset>" >> $ST.html
#       echo "<input type=\"text\" name=\"pollno\" value=\"$ST\" readonly hidden>" >>$ST.html
#       echo "<input type=\"submit\" value=\"Reveal\">" >> $ST.html
#       echo "</form>" >> $ST.html
#       echo "<a href=\"Poll/$ST.html\">$Question</a>" >> listR.html
#       echo "<br>" >> listR.html
#       echo "</html>" >> $ST.html
#       mv $ST.html Reveal/
#     fi
# done
# echo "</html>" >> listR.html
# rm allReveals

