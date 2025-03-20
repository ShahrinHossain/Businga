from django.urls import path
from dj_rest_auth.views import LoginView

from . import views
from .serializers import BalanceAdjustmentSerializer
from .views import RegisterView, LogoutView, CurrentUserInfoView, \
    AdjustBalanceView, StoppageCreateView, UpdateProfileView, AddOngoingTripView, AddBusView, AddRouteView, \
    AddBusCompanyView, FinishTripView, StoppageListView, AddToBalanceView, GetPhotoView, BusCompanyView, \
    FindNearestStoppage, CurrentTripView, ListLastTrips
    AddBusCompanyView, FinishTripView, StoppageListView, AddToBalanceView, GetPhotoView, BusCompanyView, FindNearestStoppage, \
    CurrentDriverInfoView, AddOnRouteView, DontChooseBusView




urlpatterns = [
    path('', views.all_users),
    path('register/', RegisterView.as_view(), name='register'),
    path('login/', LoginView.as_view(), name='login'),
    path('logout/', LogoutView.as_view(), name='logout'),
    path('current/', CurrentUserInfoView.as_view(), name='current'),
    path('current-owner/', BusCompanyView.as_view(), name='current-owner'),
    path('current-driver/<int:user_id>', CurrentDriverInfoView.as_view(),name='current-driver'),
    path('add-photo/', views.AddPhotoView.as_view(), name='add-photo'),
    path('update-photo/', views.UpdateFirstPhotoView.as_view(), name='update-photo'),
    path('get-photo/<int:photo_type>/', views.GetPhotoView.as_view(), name='get-photo'),
    path('drivers/<int:company_id>/', views.DriverListView.as_view(), name='driver-list'),
    path('buses/<int:company_id>/', views.BusListView.as_view(), name='bus-list'),
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
    path('add-on-route/', AddOnRouteView.as_view(), name='add-on-route'),
    path('dont-choose-bus/<int:company_id>/', DontChooseBusView.as_view(), name='dont-choose-bus'),

    path('get-nearest-stoppage/', FindNearestStoppage.as_view(), name='get-nearest-stoppage'),
    path('get-current-trip/', views.CurrentTripView.as_view(), name='get-current-trip'),

    path('list-trips/', ListLastTrips.as_view(), name='list-trips'),

    # path('verified-profile/<str:username>/', verified_driver_profile, name='verified_driver_profile'),
]