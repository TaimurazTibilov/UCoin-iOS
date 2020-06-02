from rest_framework import serializers
from .models import User


# Сериализует объект User для обработки данных
class UserSerializer(serializers.ModelSerializer):
    registration_date = serializers.ReadOnlyField()

    class Meta(object):
        model = User
        fields = ('id', 'email', 'name', 'surname',
                  'registration_date', 'photo', 'password', 'is_active', 'is_staff', 'active_balance',
                  'passive_balance')
        extra_kwargs = {'password': {'write_only': True}}
