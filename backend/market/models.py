from django.db import models
from django.db.models import DO_NOTHING

from authorization.models import User


class Item(models.Model):
    item_name = models.CharField(max_length=30)
    description = models.TextField(max_length=300)
    image = models.ImageField(blank=True)
    price = models.PositiveIntegerField()
    availability = models.PositiveIntegerField()
    is_on_sale = models.BooleanField()
    # optional fields?
    # name_ru = models.CharField(max_length=30)
    # description_ru = models.TextField(max_length=300)
    def save(self, *args, **kwargs):
        super(Item, self).save(*args, **kwargs)
        return self


class Bag(models.Model):
    customer_id = models.ForeignKey(User, related_name='customer', on_delete=DO_NOTHING)
    product_id = models.ForeignKey(Item, related_name='product', on_delete=DO_NOTHING)
    def save(self, *args, **kwargs):
        super(Bag, self).save(*args, **kwargs)
        return self