from rest_framework import serializers
from .models import Transaction


# Сериализует объект Transaction для обработки данных
class TransactionSerializer(serializers.ModelSerializer):
     class Meta(object):
        model = Transaction
        fields = ('amount', 'sender_id', 'receiver_id', 'time_stamp',
                  'description', 'is_closed', 'is_hidden','is_purchase','is_outgoing_transfer')