from django.urls import path

from .serializers import BalanceAdjustmentSerializer
from .views import RegisterView, LoginView, LogoutView, CurrentUserView, example_view, CurrentUserInfoView, \
    AdjustBalanceView, StoppageCreateView, UpdateProfileView, AddOngoingTripView
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
    path('update-profile/', UpdateProfileView.as_view(), name='update-profile'),
    path('add-ongoing-trips/', AddOngoingTripView.as_view(), name='add-ongoing-trips'),
]