import colander, deform


def list_or_tuple(seq):
    return isinstance(seq,(list,tuple))


def flatten(seq, list_or_tuple = list_or_tuple):
    for x in seq:
        if list_or_tuple(x):
            for item in flatten(x):
                yield item
        else:
            yield x


@colander.deferred
def deferred_csrf_value(node, kw):
    from pyramid.csrf import get_csrf_token
    return get_csrf_token(kw['request'])


@colander.deferred
def deferred_csrf_validator(node, kw):
    def csrf_validate(node, value):
        if value != kw['request'].session.get_csrf_token():
            raise colander.Invalid(node,
                                   'Invalid cross-site scripting token')
    return csrf_validate

class CSRFSchema(colander.Schema):
    """
    override pyramid_deform CSRFSchema
    """
    csrf_token = colander.SchemaNode(
        colander.String(),
        widget=deform.widget.HiddenWidget(),
        default=deferred_csrf_value
        )