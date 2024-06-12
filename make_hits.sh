for f in $(ls | grep score)
do
	id=$(echo $f | awk -F '_score' '{print $1}')
	cat $f | awk -v thr="$1" -F ',' '$6 >= thr' | cut -d',' -f 3-5 | awk -F, -v id="$id" 'NR==1 {header=$0; print "id," header ",total"; for (i=1; i<=NF; i++) sum[i] = 0; count=0; next} { for (i=1; i<=NF; i++) sum[i] += $i; count++ } END { printf id ","; for (i=1; i<=NF; i++) printf sum[i] OFS; print count }' OFS=, > /tmp/${id}_hits.csv
done

ls /tmp | grep _hits.csv | awk '{print "/tmp/"$1}' | xargs csvtk concat -u 0
