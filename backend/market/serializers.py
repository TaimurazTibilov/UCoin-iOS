from rest_framework import serializers
from .models import Item, Bag


# Сериализует объект Item для обработки данных
class ItemSerializer(serializers.ModelSerializer):
    class Meta(object):
        model = Item
        fields = ('item_name', 'description', 'image', 'price',
                  'availability', 'is_on_sale')

# Сериализует объект Bag для обработки данных
class BagSerializer(serializers.ModelSerializer):
    class Meta(object):
        model = Bag
        fields = ('customer_id', 'product_id')