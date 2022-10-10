#create dissociate array, use these key-value pairs to extract chromatin states & their definitions
declare -A array=(
[1]="Repressed_polycomb"
[2]="Bivalent_TSS"
[3]="Quiescent"
[4]="Poised_enhancer"
[5]="Active_enhancer_Hetero"
[6]="Weak_active_enhancer"
[7]="Transcribed_without_ATAC"
[8]="Strong_active_promoter"
[9]="Flanking_TSS"
[10]="ATAC_island"
[11]="Medium_active_enhancer"
[12]="Strong_active_enhancer"
[13]="Primed_Enhancer"
[14]="Transcribed_at_gene"
[15]="Flanking_TSS_downstream"
)

##first create a directory to put in all results for the analysis YYYY-MM-DD
DIR_TEMP=$(date +%Y_%m_%d)
DIR_FINAL="Extract_States_${DIR_TEMP}"
mkdir $DIR_FINAL

ls *dense.bed | while read BED;
  do
    for i in "${!array[@]}"
      do
      echo "Using" "key :" $i "&" "value:" ${array[$i]}
      echo "now extracting from $BED ...."
      cat $BED | awk -v var="$i" '{ if ($4 == var) print $1, $2, $3, $4}'  OFS='\t' > $DIR_FINAL"/"$BED"_"${array[$i]}".bed"
      done
  done


# create directory for each chromatin state (i.e., array value) & move extracted files
cd $DIR_FINAL
for i in "${!array[@]}"
do
    mkdir "${array[$i]}"
    find . -type f -name '*'${array[$i]}'*' -exec mv -t "${array[$i]}" {} +
done


#now go to each chromatin state directory & merge extracted bed files into one master bed file
conda activate gimme #activate conda env with bedops
for i in "${!array[@]}"
do
    cd ${array[$i]}
    echo "merging files in ->" ${array[$i]}
    #merge all 
    bedops --merge *${array[$i]}".bed" > "Combined_""${array[$i]}""_.bed"
    #sort the merged master file
    sort -k 1,1 -k2,2n "Combined_""${array[$i]}""_.bed" > "Combined_""${array[$i]}""_sorted_.bed"
    #find distance from TSS
    bedtools closest -a ../../salmon_tss.bed -b "Combined_""${array[$i]}""_sorted_.bed" \
    -D a | awk -v var=${array[$i]} 'BEGIN {FS=OFS="\t"} {print $0, var}' > "distance_from_TSS_combined_"${array[$i]}".bed"
    echo ".........."
    cd ..
done
conda deactivate

#move all distance_from_TSS files to one direcotry
DISTANCE="distance_from_TSS"
mkdir $DISTANCE
cp **/*distance* $DISTANCE

#make plot
cp ../plot_geom_histogram.R $DISTANCE
cd $DISTANCE
Rscript plot_geom_histogram.R
