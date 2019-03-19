'''
def add_route(config):
    config.add_route('list_local','/cities')
    config.add_route('view_local','/city/{name}')
    config.add_route('add_local','/add')
    config.add_route('edit_local','/{name}/edit')
    config.add_route('rate_local','/{name}/rate')
    config.add_route('delete_local','/{name}/delete')
    config.add_route('edit_local_rating','{name}/rate/{rating_id}/edit')
    config.add_route('delete_local_rating','{name}/rate/{rating_id}/delete')
    config.add_route('city_pictures','/{name}/photos')
    config.add_route('city_properties','/{name}/properties')
    config.add_route("add_city_pictures","/{name}/process-pictures")

def pic_cat_root(config):
    config.add_route("list_citypiccategory",'/list')
    config.add_route('add_citypiccategory','/add')
    config.add_route("edit_citypiccategory",'/{id}/edit')
    config.add_route("delete_citypiccategory","/{id}/delete")
'''