def postprocess_config(config):
        config["replicates"] = {}
        if "samples" in config:
                for sample in config["samples"]:
                        replicates = config["samples"][sample]
                        if not isinstance(replicates, list):
                                replicates = [replicates]
                        config["samples"][sample] = []
                        for i, replicate in enumerate(replicates):
                                name = "{}_{}".format(sample, i)
                                config["replicates"][name] = {}
                                config["replicates"][name]['r1'] = replicate
                                config["samples"][sample].append(name)
        if "paired" in config:
                for sample in config["paired"]:
                        paired_rep = config["paired"][sample]
                        if not isinstance(paired_rep, list):
                                paired_rep = [paired_rep]
                        config["paired"][sample] = []
                        for i, replicate in enumerate(paired_rep):
                                name = "{}_{}".format(sample, i)
                                config["replicates"][name]['r2'] = replicate
                                config["paired"][sample].append(name)

        # add default options if the options are missing
        # this allows MAGeCK-VISPR to work on earlier versions of config.yaml
        if 'annotate-sgrna' not in config['sgrnas']:
                config['sgrnas']['annotate-sgrna']=False
        if 'annotate-sgrna-efficiency' not in config['sgrnas']:
                config['sgrnas']['annotate-sgrna-efficiency']=False
        if 'correct_cnv' not in config:
                config['correct_cnv']=False
        if 'cnv_norm' not in config:
                config['cnv_norm']='/dev/null'


def get_norm_method(config):
        if "norm_method" in config:
                return config["norm_method"]
        elif "batchmatrix" in config:
                return "none"
        else:
                return "median"
