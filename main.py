from pyramid.paster import get_app,setup_logging
init_path = "production.ini"
setup_logging(init_path)
app = get_app(init_path, 'main')
