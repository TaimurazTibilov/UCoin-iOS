from django.db import models
from django.db.models import DO_NOTHING, Model
from django.utils import timezone

from authorization.models import User


# Класс представляет собой транзакцию с данными об отправителе и получателе
class Transaction(models.Model):
    amount = models.DecimalField(max_digits=12, decimal_places=2)
    # ID отправителя (OneToMany)
    sender_id = models.ForeignKey(User, related_name='sender', on_delete=DO_NOTHING)
    # ID получателя  (OneToMany)
    receiver_id = models.ForeignKey(User, related_name='receiver', on_delete=DO_NOTHING)
    time_stamp = models.DateTimeField(default=timezone.now())
    description = models.CharField(max_length=600)
    is_closed = models.BooleanField(default=False)
    is_hidden = models.BooleanField(default=False)
    is_purchase = models.BooleanField(default=False)
    is_outgoing_transfer = models.BooleanField(default=False)


    def save(self, *args, **kwargs):
        super(Transaction, self).save(*args, **kwargs)
        return self
