import os
import sys


from sqlalchemy import engine_from_config

from pyramid.paster import (
    get_appsettings,
    setup_logging,
    ) 
from buddy.models.user_model import init_model
from buddy.models.populate import (populate_category,
                                   populate_location,
                                   add_blog_category,
                                   populate_userTypes,
                                   populate_features,
                                  # Populate_FeatureToRate,
                                   populate_superuser,
                                   #add_Qcategory
                                   )

def usage(argv):
    cmd = os.path.basename(argv[0])
    print('usage: %s <config_uri>\n'
          '(example: "%s development.ini")' % (cmd, cmd))
    sys.exit(1)


def main(argv=sys.argv):
    if len(argv) != 2:
        usage(argv)
    config_uri = argv[1]
    setup_logging(config_uri)
    settings = get_appsettings(config_uri)
    engine = engine_from_config(settings, 'sqlalchemy.')
    init_model(engine)
    populate_category()
    add_blog_category()
    populate_location()
    populate_userTypes()
    #add_Qcategory()
    populate_features()
    #Populate_FeatureToRate()
    populate_superuser()