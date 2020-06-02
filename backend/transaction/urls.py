from django.urls import path
from transaction import views

urlpatterns = [
    path('transactions/', views.transaction_list),
    path('transactions/<int:pk>/', views.transaction_detail),
    path('transactions/receiver_history/<int:pk>/', views.user_history_list_receiver),
    path('transactions/sender_history/<int:pk>/', views.user_history_list_sender),
    path('transactions/create/', views.transaction_create),
]