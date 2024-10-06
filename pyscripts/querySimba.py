#!/bin/python3
from astroquery.simbad import Simbad

#import json

#path = "closest_5k_by_dist.txt"
#path = "brightest_50k_simbad.txt"

r = Simbad.query_tap("""SELECT TOP 5000
                      oid,vmag,ra,dec,otype_txt
                      FROM basic
                      WHERE otype_txt = 'star..'
                      ORDER BY vmag ASC""")
#                      output_file=path, output_format="json", dump_to_file=True)

#r["calculated_new_v"] = r["phot_g_mean_mag"] + 0.0176 + 0.00686*(r["phot_bp_mean_mag"] - r["phot_rp_mean_mag"]) + 0.1732*(r["phot_bp_mean_mag"] - r["phot_rp_mean_mag"])**2
#print(json.dumps(r["data"]))
r.pprint()
