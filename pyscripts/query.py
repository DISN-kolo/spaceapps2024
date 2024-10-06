#!/bin/python3
from astroquery.gaia import Gaia

import json

#path = "closest_5k_by_dist.txt"
path = "brightest_5k_by_g_magn.txt"

job = Gaia.launch_job("select top 1000 \
                      phot_g_mean_mag,phot_bp_mean_mag,phot_rp_mean_mag,parallax,ra,dec,source_id,teff_gspphot \
                      from gaiadr3.gaia_source \
                      where parallax is not null and phot_g_mean_mag is not null and phot_bp_mean_mag is not null and phot_rp_mean_mag is not null \
                      order by phot_g_mean_mag",
                      output_file=path, output_format="json", dump_to_file=True)

r = job.get_results()
#r["calculated_new_v"] = r["phot_g_mean_mag"] + 0.0176 + 0.00686*(r["phot_bp_mean_mag"] - r["phot_rp_mean_mag"]) + 0.1732*(r["phot_bp_mean_mag"] - r["phot_rp_mean_mag"])**2
#print(json.dumps(r["data"]))
r.pprint()
