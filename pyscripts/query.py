#!/bin/python3
from astroquery.gaia import Gaia

path = "closest_5k_by_dist.txt"

job = Gaia.launch_job("select top 5000 "
                      "parallax,ra,dec,source_id "
                      "from gaiadr3.gaia_source where parallax is not null "
                      "order by parallax desc",
                      output_file=path, output_format="json", dump_to_file=True)

r = job.get_results()
r.pprint()
