from __future__ import unicode_literals
from django.db import models, transaction
from django.utils import timezone
from django.contrib.auth.models import (
    AbstractBaseUser,
    PermissionsMixin,
    BaseUserManager,
)


# Класс-менеджер, позволяет работать с объектами пользователей
class UserManager(BaseUserManager):

    # По своей сути закрытый метод создания нового пользователя
    def _create_user(self, email, password, **extra_fields):
        if not email:
            raise ValueError('The given email must be set')
        try:
            with transaction.atomic():
                user = self.model(email=email, **extra_fields)
                user.set_password(password)
                user.save(using=self._db)
                return user
        except:
            raise

    # Метод создания простого пользователя
    def create_user(self, email, password=None, **extra_fields):
        extra_fields.setdefault('is_staff', False)
        extra_fields.setdefault('is_superuser', False)
        return self._create_user(email, password, **extra_fields)

    # Метод создания суперпользователя
    def create_superuser(self, email, password, **extra_fields):
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)

        return self._create_user(email, password=password, **extra_fields)


# Класс пользователя с полями, которые мигрируют в БД
class User(AbstractBaseUser, PermissionsMixin):
    name = models.CharField(max_length=30)
    surname = models.CharField(max_length=30)
    email = models.EmailField(max_length=50, unique=True)
    photo = models.ImageField(upload_to='../uploads/', blank=True) # default='../uploads/unknown.png'
    registration_date = models.DateTimeField(default=timezone.now())
    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)
    active_balance = models.IntegerField(default=100, blank=True)
    passive_balance = models.IntegerField(default=0, blank=True)

    objects = UserManager()

    # Необходимое поле для авторизации
    USERNAME_FIELD = 'email'

    # Данные, без которых сохранение пользователя невозможно
    REQUIRED_FIELDS = [
        'name',
        'surname',
    ]

    # Метод сохранения данных пользователя в БД
    def save(self, *args, **kwargs):
        super(User, self).save(*args, **kwargs)
        return self


