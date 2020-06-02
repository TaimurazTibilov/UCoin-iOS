from django.conf.urls import url
from django.urls import path
from .views import CreateUserAPIView, authenticate_user, UserRetrieveUpdateAPIView, users_list, user_detail, find_user_by_name

urlpatterns = [
    url(r'^create/$', CreateUserAPIView.as_view()),
    url(r'^obtain_token/$', authenticate_user),
    url(r'^update/$', UserRetrieveUpdateAPIView.as_view()),
    url(r'^users/$', users_list),
    path('<int:pk>/', user_detail),
    path('<str:pk>/', find_user_by_name),
]