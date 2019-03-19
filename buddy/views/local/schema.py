'''from formencode import validators, Schema, All, Invalid
from buddy.models import DBSession
from buddy.models.city_model import Locality






class Unique(validators.FancyValidator):
    """Validator to ensure that the value of a field is unique"""

    def __init__(self, fieldName, errorMessage):
        'Store fieldName and errorMessage'
        super(Unique, self).__init__()
        self.fieldName = fieldName
        self.errorMessage = errorMessage

    def _to_python(self, value, state):
        'Check whether the value is unique'
        if DBSession.query(Locality).filter(getattr(Locality, self.fieldName)==value).first():
            raise Invalid(self.errorMessage, value, state)
        # Return
        return value


class CreateLocal(Schema):
    
    allow_extra_fields = True
    filter_extra_fields = True
    
    state_id = validators.Int(not_empty=True, messages={'empty':"Please select a state"})
    city_name = All(
        validators.UnicodeString(not_empty=True, messages={'empty':'Please enter a city'}),
        Unique('city_name','This city already exist. search for it'))

class PicCategorySchema(Schema):
    allow_extra_fields = True
    filter_extra_fields = True

    name = validators.UnicodeString(not_empty=True)

class PicUploadSchema(Schema):
    allow_extra_fields = True
    filter_extra_fields = True

    category_id = validators.Int(not_empty=True)
    filename = validators.String(not_empty=True)
    title = validators.UnicodeString(not_empty=True)

class RatingSchema(Schema):
    allow_extra_fields = True
    filter_extra_fields = True

    title = validators.UnicodeString()
    review = validators.UnicodeString(not_empty=True)
    overall_rating = validators.Number(not_empty=True)
    roads = validators.UnicodeString(not_empty=True)
    safety = validators.UnicodeString(not_empty=True)
    cleanliness = validators.UnicodeString(not_empty=True)
    neighborhood = validators.UnicodeString(not_empty=True)
    public_transport = validators.UnicodeString(not_empty=True)
'''