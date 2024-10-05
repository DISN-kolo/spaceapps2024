#!/bin/python3
from astroquery.gaia import Gaia

#path = "closest_5k_by_dist.txt"
path = "brightest_5k_by_g_magn.txt"

job = Gaia.launch_job("select top 5000 \
                      phot_g_mean_mag,phot_bp_mean_mag,phot_rp_mean_mag,parallax,ra,dec,source_id \
                      from gaiadr3.gaia_source \
                      where parallax is not null \
                      order by phot_g_mean_mag asc",
                      output_file=path, output_format="json", dump_to_file=True)

r = job.get_results()
r.pprint()
