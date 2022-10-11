# Map chromHMM state distance from TSS

## What
Use these scripts to create histogram of 'chromHMM-defined chromatin states' around TSS

## How
Working directory should contain these three files plus dense.bed outputs from the chromHMM analysis
- chromHMM_state_density_at_TSS.sh (main bash script, run this!!)
- plot_geom_density.R (supporting script, creates geom_histogram of TSS distance)
- salmon_tss.bed (supporting file, bed file for TSS coordinate of Atlantic salmon ensembl gene IDs)


## Output
- All results will be inside <Extract_States_YYYY-MM-DD> directory
- Check main results & plots in <distance_from_TSS directory>
