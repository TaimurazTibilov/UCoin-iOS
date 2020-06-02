from django.urls import path
from market import views

urlpatterns = [
    path('market/bag', views.bag_detail),
    path('market/items', views.item_list),
    path('market/items/<int:pk>/', views.item_detail),
]