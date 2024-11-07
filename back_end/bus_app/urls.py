from django.urls import path
from .views import RegisterView, LoginView, LogoutView
from . import views

urlpatterns = [
    path('', views.all_users),
    path('register/', RegisterView.as_view(), name='register'),
    path('login/', LoginView.as_view(), name='login'),
    path('logout/', LogoutView.as_view(), name='logout'),
]