snakemake -s Snakefile -p \
        --jobs 999 --latency-wait 900 --printshellcmds --rerun-incomplete --cluster-config cluster.yaml \
        --cluster "sbatch --mem={cluster.mem} \
                        --ntasks={cluster.ntasks} \
                        --cpus-per-task={cluster.cpus-per-task} \
                        --time={cluster.time} \
                        --hint={cluster.hint} \
                        --output={cluster.output} \
                        --error={cluster.error}"
