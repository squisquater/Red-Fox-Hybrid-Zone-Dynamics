mkdir trimmed
for file in $(ls /mnt/iguana/MECU/Data_Shared_Iguana/20190930SophieGBS-RF-4/Project_BSSQ_L3_Sophie4_SPQ/Project_BSSQ_L3_Sophie4/Demultiplexed/*.gz)
do perl /usr/bin/ngsShoRT_2.2/ngsShoRT.pl -t 2 -se ${file} -5a_f i-m -o ./trimmed -methods lqr -lqs 2 -lq_p 50
done

## This is an example of the trimming script used on demultiplexed reads for a single hiseq library
#This script uses ngsShoRT to specify the use of two threads (-t 2)
#single end reads (-se)
#trim off any remaining 5’ adapter sequences that are illumina multiplex specific (-5a_f i-m)
#and trims reads with >50% of bases having a quality score of <2 (-methods lqr -lqs 2 -lq_p 50)
