from buddy.models.properties_model import State, PropertyCategory
from buddy.models.properties_model import  Feature_types,Features
from buddy.models.user_model import User_types, Users, Groups
from buddy.models.blogs_model import BlogCategory
from buddy.models.q_model import QCategory, Questions, Answers
#from buddy.models.city_model import FeatureToRate

from buddy.models import DBSession
import transaction


def populate_userTypes():
        usertypes = [u'Buyer/Seller',u'Real Estate Developer/Builder',u'Real Estate Agent',u'Mortgage Lender',u'LandLord',
                     u'Real Estate Broker',u'Property Manager',u'Other/just Looking']
        with transaction.manager:
                for name in usertypes:
                        typs = User_types(
                                name)
                        DBSession.add(typs)

def populate_category():
        root_category_1 = PropertyCategory(name=u'Residential')
        #Adding subcategories for Residential,

        #PropertyCategory(u"Multistorey Apartment/Flat",parent=root_category_1)
        #PropertyCategory(u"Story Apartment/Flat", parent=root_category_1)
        PropertyCategory(u"Flat",parent=root_category_1)
        PropertyCategory(u"Residential House",parent=root_category_1)
        PropertyCategory(u"Residential Land", parent=root_category_1)
        #PropertyCategory(u"Self-Contained/Studio House",parent=root_category_1)
        #PropertyCategory(u"Serviced Apartment",parent=root_category_1)
        #PropertyCategory(u"Penthouse",parent=root_category_1)


        root_category_2 = PropertyCategory(name=u"Commercial")
        #Adding subcategories for commercial
        PropertyCategory(u"Office space",parent=root_category_2)
        PropertyCategory(u"Commercial Shop",parent=root_category_2)
        PropertyCategory(u"Space in Shopping Mall",parent=root_category_2)
        PropertyCategory(u"Commercial Showroom",parent=root_category_2)
        #PropertyCategory(u"Business Centre",parent=root_category_2)
        PropertyCategory(u"Commercial Land",parent=root_category_2)
        PropertyCategory(u"Warehouse",parent=root_category_2)
        PropertyCategory(u"Guest House",parent=root_category_2)
        PropertyCategory(u"Hotel",parent=root_category_2)
        PropertyCategory(u"Hotel Sites",parent=root_category_2)#land
        PropertyCategory(u"Industrial Land",parent=root_category_2)
        PropertyCategory(u"Industrial Building",parent=root_category_2)


        root_category_3 = PropertyCategory(name=u"Agricultural")
        #adding subcategories for Agricultural
        PropertyCategory(u"Agricultural Land",parent=root_category_3)
        PropertyCategory(u"Farm House",parent=root_category_3)

        with transaction.manager:
                DBSession.add_all([root_category_1, root_category_2, root_category_3])


def populate_location():
        states=[u"Abuja",u"Abia",u"Anambra",u"Adamawa",u"Akwa Ibom",u"Bauchi",u"Benue",
         u"Bayelsa",u"Borno",u"Cross River",u"Enugu",u"Ebonyi",u"Edo",u"Ekiti",u"Delta",
         u"Gombe",u"Imo",u"Jigawa",u"Kebbi",u"Kogi",u"Kwara",u"Kano",u"Kaduna",u"Katsina",
         u"Lagos",u"Nasarawa",u"Niger",u"Osun",u"Ogun",u"Oyo",u"Ondo",u"Rivers",u"Plateau",
         u"Taraba",u"Sokoto",u"Yobe",u"Zamfara"]
        with transaction.manager:
                for state in states:
                        s = State(state)
                        DBSession.add(s)

def add_blog_category():
        c1 = BlogCategory(name=u'Home selling')
        c2 = BlogCategory(name=u'Mortgage')
        c3 = BlogCategory(name=u'Rentals')
        c4 = BlogCategory(name=u'Local topics')
        c5 = BlogCategory(name=u'Home ownership')
        c6 = BlogCategory(name=u'Pro-to-pro')
        c7 = BlogCategory(name=u'Home buying')
        c8 = BlogCategory(name=u'Nairabricks Blogs')

        home_selling = [u'Selling process',u'Pricing',u'When to sell',
                        u'Housing market', u'for sale by owner']
        mortgage = [u'mortgage rates',u'refinance',u'home equity loans',u'credit scores',
                    u'approval process',u'mortgage types',u'loan modifications']
        rental = [u'rental market',u'finding a rental',u'Rental rights']
        local = [u'neighborhoods',u'market conditions',u'schools',u'crime',u'Parks and Recreation',u'Local Info']
        ownership = [u'home improvement',u'maintenance',u'taxes',u'insurance']
        pro = [u'agents',u'lenders',u'landlords',u'other pros',u'success stories']
        home_buying = [u'buying process',u'buying a foreclosure',u'rent vs buy',u'investing']
        nairabricks = [u'for sale listing',u'rental listing',u'Bugs & Suggestions',
                       u'Discussion']
        with transaction.manager:
                for c in home_selling:
                        q = BlogCategory(name=c,parent=c1)
                for c in mortgage:
                        q = BlogCategory(name=c,parent=c2)
                for c in rental:
                        q = BlogCategory(name=c,parent=c3)
                for c in local:
                        q = BlogCategory(name=c,parent=c4)
                for c in ownership:
                        q = BlogCategory(name=c,parent=c5)
                for c in pro:
                        q = BlogCategory(name=c,parent=c6)
                for c in home_buying:
                        q = BlogCategory(name=c,parent=c7)
                for c in nairabricks:
                        q = BlogCategory(name=c,parent=c8)
                DBSession.add_all([c1,c2,c3,c4,c5,c6,c7,c8])
'''
def add_Qcategory():
        c1 = QCategory(name=u'Home selling')
        c2 = QCategory(name=u'Mortgage')
        c3 = QCategory(name=u'Rentals')
        c4 = QCategory(name=u'Local topics')
        c5 = QCategory(name=u'Home ownership')
        c6 = QCategory(name=u'Pro-to-pro')
        c7 = QCategory(name=u'Home buying')
        c8 = QCategory(name=u'Nairabricks Questions')

        home_selling = [u'Selling process',u'Pricing',u'When to sell',
                        u'Housing market', u'for sale by owner']
        mortgage = [u'mortgage rates',u'refinance',u'home equity loans',u'credit scores',
                    u'approval process',u'mortgage types',u'loan modifications']
        rental = [u'rental market',u'finding a rental',u'Rental rights']
        local = [u'neighborhoods',u'market conditions',u'schools',u'crime',u'Parks and Recreation',u'Local Info']
        ownership = [u'home improvement',u'maintenance',u'taxes',u'insurance']
        pro = [u'agents',u'lenders',u'landlords',u'other pros',u'success stories']
        home_buying = [u'buying process',u'buying a foreclosure',u'rent vs buy',u'investing']
        nairabricks = [u'for sale listing',u'rental listing',u'Bugs & Suggestions',
                       u'Discussion']
        with transaction.manager:
                for c in home_selling:
                        q = QCategory(name=c,parent=c1)
                for c in mortgage:
                        q = QCategory(name=c,parent=c2)
                for c in rental:
                        q = QCategory(name=c,parent=c3)
                for c in local:
                        q = QCategory(name=c,parent=c4)
                for c in ownership:
                        q = QCategory(name=c,parent=c5)
                for c in pro:
                        q = QCategory(name=c,parent=c6)
                for c in home_buying:
                        q = QCategory(name=c,parent=c7)
                for c in nairabricks:
                        q = QCategory(name=c,parent=c8)
                DBSession.add_all([c1,c2,c3,c4,c5,c6,c7,c8])
'''

def populate_features():
        external = Feature_types(u'External Features')
        internal = Feature_types(u'Internal Features')
        eco = Feature_types(u'Eco Features')
        other = Feature_types(u'Other Features')

        oth = [u'Pets Allowed', u'Disability Features',u'Waterfront', u'Water View',
               u'Ocean View', u'River View',u'Hill/Mountain View', u'Development Projects']
        inter = [u'Alarm System', u'Intercom',u'Ensuite', u'Dishwasher',
               u'Built-in wardrobes', u'Ducted vacuum system',u'Gym', u'Indoor spa',
               u'Floorboards', u'Broadband internet available',u'Pay TV access', u'Fireplace',
               u'Ducted', u'heating', u'Ducted cooling',u'Split-system heating',
               u'Hydronic heating',u'Air conditioning', u'Gas heating',u'Lift']
        ext =[u'Carport', u'Garage',u'Open car spaces', u'Remote garage',
              u'Secure parking', u'Swimming pool',u'Tennis court', u'Balcony',
              u'Deck', u'Courtyard',u'Outdoor entertaining area', u'Fully fenced']
        ec = [u'Solar panels', u'Solar hot water',u'Water tank', u'Grey water system',
              u'High Energy efficiency rating', u'Medium Energy efficiency rating',
              u'Low - Energy efficiency rating']
        with transaction.manager:
                for c in inter:
                        indoor = Features(name=c)
                        DBSession.add(indoor)
                        internal.features.append(indoor)
                for e in ext:
                        outdoor = Features(name=e)
                        DBSession.add(outdoor)
                        external.features.append(outdoor)
                for i in ec:
                        ecof = Features(name=i)
                        DBSession.add(ecof)
                        eco.features.append(ecof)
                for o in oth:
                        othr = Features(name=o)
                        DBSession.add(othr)
                        other.features.append(othr)
                DBSession.add_all([external,internal,eco])
                transaction.commit()
'''
def Populate_FeatureToRate():
        env = FeatureToRate(name=u'Environment')
        com = FeatureToRate(name=u'Commuting')
        place = FeatureToRate(name=u'Places of Interest')

        d = [u'Roads',u'Safety',u'Cleanliness',u'Neighborhood']
        c = [u'Public Transport',u'Parking',u'Connectivity',u'Traffic']
        e =[u'Schools',u'Restaurants',u'Hospital',u'Market']
        with transaction.manager:
                for i in d:
                      enviro = FeatureToRate(name=i, parent=env)
                for i in c:
                        come = FeatureToRate(name=i, parent=com)
                for i in e:
                        s = FeatureToRate(name=i, parent=place)
                DBSession.add_all([env,com,place])
                transaction.commit()
'''

def populate_superuser():
    admin = Users(
        firstname = u"Ephraim",
        surname = u"Anierobi",
        password = u"mypassword",
        email = u"splendidzigy24@gmail.com",
        company_name=u"Zebraware Group Ltd",
        prefix = u"Zebraware",
        email_verified = True
    )
    group1 = Groups(name=u"superadmin", description=u"Last Admin")
    group2 = Groups(name=u"admin", description=u"Admin")
    group3 = Groups(name=u"supermod",description=u"Super moderator")
    group4 = Groups(name=u"mod", description=u"Moderator")
    with transaction.manager:
        DBSession.add_all([group1,group2,group3,group4])
        admin.mygroups.append(group1)