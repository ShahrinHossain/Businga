from django.urls import path
from dj_rest_auth.views import LoginView
from .serializers import BalanceAdjustmentSerializer
from .views import RegisterView, LogoutView, example_view, CurrentUserInfoView, \
    AdjustBalanceView, StoppageCreateView, UpdateProfileView, AddOngoingTripView, AddBusView, AddRouteView, \
    AddBusCompanyView, FinishTripView, StoppageListView, AddToBalanceView, \
    register_driver, DriverLoginView, DriverLogoutView, driver_profile, \
    StartDriverTripView, DriverTripListView, FinishDriverTripView, AssignDriverToBusView
from . import views

urlpatterns = [
    path('', views.all_users),
    path('register/', RegisterView.as_view(), name='register'),
    path('login/', LoginView.as_view(), name='login'),
    path('logout/', LogoutView.as_view(), name='logout'),
    path('current/', CurrentUserInfoView.as_view(), name='current'),
    path('example/', example_view, name='example-view'),
    path('update-balance/', AdjustBalanceView.as_view(), name='update-balance'),
    path('make-payment/', AddToBalanceView.as_view(), name='make-payment'),
    path('add-stoppage/', StoppageCreateView.as_view(), name='add-stoppage'),
    path('stoppage-list/', StoppageListView.as_view(), name='stoppage-list'),
    path('update-profile/', UpdateProfileView.as_view(), name='update-profile'),
    path('add-ongoing-trips/', AddOngoingTripView.as_view(), name='add-ongoing-trips'),
    path('finish-trip/', FinishTripView.as_view(), name='finish-trip'),
    path('add-bus/', AddBusView.as_view(), name='add-bus'),
    path('add-route/', AddRouteView.as_view(), name='add-route'),
    path('bus-companies/', AddBusCompanyView.as_view(), name='add_bus_company'),

    path('driver/register/', register_driver, name='register_driver'),
    path('driver/login/', DriverLoginView.as_view(), name='driver_login'),
    path('driver/logout/', DriverLogoutView.as_view(), name='driver_logout'),
    path('driver/profile/', driver_profile, name='driver_profile'),
    path('driver/start-trip/', StartDriverTripView.as_view(), name='start_driver_trip'),
    path('driver/trips/', DriverTripListView.as_view(), name='driver_trips'),
    path('driver/finish-trip/', FinishDriverTripView.as_view(), name='finish_driver_trip'),
    path('driver/assign-bus/', AssignDriverToBusView.as_view(), name='assign_driver_to_bus'),

]