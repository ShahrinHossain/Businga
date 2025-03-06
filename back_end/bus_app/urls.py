from django.urls import path
from dj_rest_auth.views import LoginView
from .serializers import BalanceAdjustmentSerializer
from .views import RegisterView, LogoutView, example_view, CurrentUserInfoView, \
    AdjustBalanceView, StoppageCreateView, UpdateProfileView, AddOngoingTripView, AddBusView, AddRouteView, \
    AddBusCompanyView, FinishTripView, StoppageListView
from . import views

urlpatterns = [
    path('', views.all_users),
    path('register/', RegisterView.as_view(), name='register'),
    path('login/', LoginView.as_view(), name='login'),
    path('logout/', LogoutView.as_view(), name='logout'),
    path('current/', CurrentUserInfoView.as_view(), name='current'),
    path('example/', example_view, name='example-view'),
    path('update-balance/', AdjustBalanceView.as_view(), name='update-balance'),
    path('add-stoppage/', StoppageCreateView.as_view(), name='add-stoppage'),
    path('stoppage-list/', StoppageListView.as_view(), name='stoppage-list'),
    path('update-profile/', UpdateProfileView.as_view(), name='update-profile'),
    path('add-ongoing-trips/', AddOngoingTripView.as_view(), name='add-ongoing-trips'),
    path('finish-trip/', FinishTripView.as_view(), name='finish-trip'),
    path('add-bus/', AddBusView.as_view(), name='add-bus'),
    path('add-route/', AddRouteView.as_view(), name='add-route'),
    path('bus-companies/', AddBusCompanyView.as_view(), name='add_bus_company'),
]