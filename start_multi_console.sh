START_ID=$1
END_ID=$2

let c=($END_ID-$START_ID)/200+1
for ((i=0; i<c; i++))
do
a=$[200*i]
a=$[START_ID+a]
echo $a
b=$[i+1]
b=$[200*b]
b=$[START_ID+b-1]

if [ $b -gt $END_ID ]
then
b=$END_ID
fi

echo $b

# node main.js g 6 $a  $b 1234
echo "nohup sh start_console.sh ${a} ${b} &" |bash;
sleep 1
echo "-------------"
done
