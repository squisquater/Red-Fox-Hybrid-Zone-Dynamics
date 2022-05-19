#!/bin/bash
#SBATCH -t 10:00:00
#SBATCH -p med
#SBATCH --mem 1GB
#SBATCH -o "align.out"

list=$1
ref=$2

wc=$(wc -l ${list} | awk '{print $1}')

x=1
while [ $x -le $wc ]
do
        string="sed -n ${x}p ${list}"
        str=$($string)

        var=$(echo $str | awk -F"\t" '{print $1, $2}')
        set -- $var
        c1=$1
        c2=$2

        echo "#!/bin/bash -l
        bwa mem $ref ${c1}.fastq.gz > ${c1}.sam
        samtools view -F 4 -q 10 -bS ${c1}.sam | samtools sort -o ${c1}.sort.bam
        samtools index ${c1}.sort.bam" > ${c1}.sh
        sbatch -t 4:00:00 --mem=8G ${c1}.sh

        x=$(( $x + 1 ))

done
