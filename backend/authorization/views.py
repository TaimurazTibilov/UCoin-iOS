import jwt
from django.contrib.auth import user_logged_in
from rest_framework import status
from rest_framework.decorators import api_view, permission_classes
from rest_framework.generics import RetrieveUpdateAPIView
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework_jwt.serializers import jwt_payload_handler
from django.views.decorators.csrf import csrf_exempt
from django.http import HttpResponse, JsonResponse
from rest_framework.parsers import JSONParser

from authorization.models import User
from authorization.serializers import UserSerializer
from ucoin import settings


# Класс предоставляет инструменты для создания нового пользователя в запросе
class CreateUserAPIView(APIView):
    # Позволяет всем пользователям обратиться к данному классу API
    permission_classes = (AllowAny,)

    # Получает данные из запроса и сохраняет их через сериализатор
    def post(self, request):
        user = request.data
        serializer = UserSerializer(data=user)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response(serializer.data, status=status.HTTP_201_CREATED)


# Эта функция работает странно, но главное работает (Позволяет аутентифицировать пользователя)
@api_view(['POST'])
@permission_classes([AllowAny, ])
def authenticate_user(request):
    try:
        email = request.data['email']
        password = request.data['password']

        user = User.objects.get(email=email, password=password)
        if user:
            try:
                payload = jwt_payload_handler(user)
                token = jwt.encode(payload, settings.SECRET_KEY)
                user_details = {}
                user_details['name'] = "%s %s" % (
                    user.name, user.surname)
                user_details['token'] = token
                # TODO: Add balance and photo of a user
                user_logged_in.send(sender=user.__class__,
                                    request=request, user=user)
                return Response(user_details, status=status.HTTP_200_OK) # Возвращает токен и пользователя

            except Exception as e:
                raise e
        else:
            res = {
                'error': 'can not authenticate with the given credentials or the account has been deactivated'}
            return Response(res, status=status.HTTP_403_FORBIDDEN) # Если пароль/логин неправильные
    except KeyError:
        res = {'error': 'please provide a email and a password'}
        return Response(res, status=status.HTTP_400_BAD_REQUEST) # Если в запросе не было логина/пароля


# При успешной авторизации отправляет и обновляет данные о пользователе
class UserRetrieveUpdateAPIView(RetrieveUpdateAPIView):
    # Запрос могут отправлять только авторизованные пользователи
    permission_classes = (IsAuthenticated,)
    serializer_class = UserSerializer

    def get(self, request, *args, **kwargs):
        # Сериализует данные о пользователе и отправляет в ответе, если запрос типа GET
        serializer = self.serializer_class(request.user)

        return Response(serializer.data, status=status.HTTP_200_OK)

    def put(self, request, *args, **kwargs):
        serializer_data = request.data.get('user', {})

        serializer = UserSerializer(
            request.user, data=serializer_data, partial=True
        )
        serializer.is_valid(raise_exception=True)
        serializer.save() # Обновляет данные о пользователе, если запрос типа PUT

        return Response(serializer.data, status=status.HTTP_200_OK)


# TODO: Дописать методы для работы с наборами пользователей
class UserListAPI(APIView):
    permission_classes(IsAuthenticated, )
    user_list = User.objects.all()

    def get(self, request, *args, **kwargs):
        serializer = UserSerializer(

        )


@csrf_exempt
def users_list(request):
    """
    List all code snippets, or create a new snippet.
    """
    if request.method == 'GET':
        item = User.objects.all()
        serializer = UserSerializer(item, many=True)
        return JsonResponse(serializer.data, safe=False)

    elif request.method == 'POST':
        data = JSONParser().parse(request)
        serializer = UserSerializer(data=data)
        if serializer.is_valid():
            serializer.save()
            return JsonResponse(serializer.data, status=201)
        return JsonResponse(serializer.errors, status=400)

@csrf_exempt
def user_detail(request, pk):
    try:
        item = User.objects.get(pk=pk)
    except User.DoesNotExist:
        return HttpResponse(status=404)

    if request.method == 'GET':
        serializer = UserSerializer(item)
        return JsonResponse(serializer.data)

    elif request.method == 'PUT':
        data = JSONParser().parse(request)
        serializer = UserSerializer(item, data=data)
        if serializer.is_valid():
            serializer.save()
            return JsonResponse(serializer.data)
        return JsonResponse(serializer.errors, status=400)

    elif request.method == 'DELETE':
        item.delete()
        return HttpResponse(status=204)

@csrf_exempt
def find_user_by_name(request, pk):
    find_by_surname = False
    try:
        item = User.objects.get(name__contains=pk)
    except User.DoesNotExist:
        find_by_surname = True
    if (find_by_surname):
        try:
            item = User.objects.get(surname__contains=pk)
        except User.DoesNotExist:
            return HttpResponse(status=404)

    if request.method == 'GET':
        serializer = UserSerializer(item)
        return JsonResponse(serializer.data)

    elif request.method == 'PUT':
        data = JSONParser().parse(request)
        serializer = UserSerializer(item, data=data)
        if serializer.is_valid():
            serializer.save()
            return JsonResponse(serializer.data)
        return JsonResponse(serializer.errors, status=400)

    elif request.method == 'DELETE':
        item.delete()
        return HttpResponse(status=204)