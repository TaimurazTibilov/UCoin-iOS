from django.http import HttpResponse, JsonResponse
from django.views.decorators.csrf import csrf_exempt
from rest_framework.parsers import JSONParser
from transaction.models import Transaction
from transaction.serializers import TransactionSerializer
from authorization.views import User


# Create your views here.

@csrf_exempt
def transaction_list(request):
    """
    List all code snippets, or create a new snippet.
    """
    if request.method == 'GET':
        transaction = Transaction.objects.all()
        serializer = TransactionSerializer(transaction, many=True)
        return JsonResponse(serializer.data, safe=False)

    elif request.method == 'POST':
        data = JSONParser().parse(request)
        serializer = TransactionSerializer(data=data)
        if serializer.is_valid():
            serializer.save()
            return JsonResponse(serializer.data, status=201)
        return JsonResponse(serializer.errors, status=400)


@csrf_exempt
def transaction_detail(request, pk):
    try:
        transaction = Transaction.objects.get(pk=pk)
    except Transaction.DoesNotExist:
        return HttpResponse(status=404)

    if request.method == 'GET':
        serializer = TransactionSerializer(transaction)
        return JsonResponse(serializer.data)

    elif request.method == 'PUT':
        data = JSONParser().parse(request)
        serializer = TransactionSerializer(transaction, data=data)
        if serializer.is_valid():
            serializer.save()
            return JsonResponse(serializer.data)
        return JsonResponse(serializer.errors, status=400)

    elif request.method == 'DELETE':
        transaction.delete()
        return HttpResponse(status=204)


@csrf_exempt
def transaction_create(request):
    # User.objects.get(data.sender_id)
    if request.method == 'POST':
        data = JSONParser().parse(request)
        print(data)
        sender = User.objects.get(id=data["sender_id"])
        receiver = User.objects.get(id=data["receiver_id"])
        amount = int(data["amount"])
        if sender.is_active and sender.passive_balance + sender.active_balance > amount and receiver.is_active:
            Transaction.objects.create(sender_id=sender, receiver_id=receiver, amount=amount,
                                       description=data["description"])
            sender.active_balance -= amount
            receiver.passive_balance += amount
            sender.save()
            receiver.save()
            return HttpResponse(status=200)
        else:
            return HttpResponse(status=422)


@csrf_exempt
def user_history_list(request, pk):
    try:

        transaction = Transaction.objects.filter(sender_id=pk) + Transaction.objects.filter(receiver_id=pk)
    except Transaction.DoesNotExist:
        return HttpResponse(status=404)

    if request.method == 'GET':
        serializer = TransactionSerializer(transaction)
        return JsonResponse(serializer.data)

    elif request.method == 'PUT':
        data = JSONParser().parse(request)
        serializer = TransactionSerializer(transaction, data=data)
        if serializer.is_valid():
            serializer.save()
            return JsonResponse(serializer.data)
        return JsonResponse(serializer.errors, status=400)

    elif request.method == 'DELETE':
        transaction.delete()
        return HttpResponse(status=204)


@csrf_exempt
def user_history_list_sender(request, pk):
    try:
        transaction = Transaction.objects.all().filter(sender_id=pk)
    except Transaction.DoesNotExist:
        return HttpResponse(status=404)

    if request.method == 'GET':
        serializer = TransactionSerializer(transaction, many=True)
        return JsonResponse(serializer.data, safe=False)

    elif request.method == 'PUT':
        data = JSONParser().parse(request)
        serializer = TransactionSerializer(transaction, data=data)
        if serializer.is_valid():
            serializer.save()
            return JsonResponse(serializer.data)
        return JsonResponse(serializer.errors, status=400)

    elif request.method == 'DELETE':
        transaction.delete()
        return HttpResponse(status=204)


@csrf_exempt
def user_history_list_receiver(request, pk):
    try:
        transaction = Transaction.objects.all().filter(receiver_id=pk)
    except Transaction.DoesNotExist:
        return HttpResponse(status=404)

    if request.method == 'GET':
        serializer = TransactionSerializer(transaction, many=True)
        return JsonResponse(serializer.data, safe=False)

    elif request.method == 'PUT':
        data = JSONParser().parse(request)
        serializer = TransactionSerializer(transaction, data=data)
        if serializer.is_valid():
            serializer.save()
            return JsonResponse(serializer.data)
        return JsonResponse(serializer.errors, status=400)

    elif request.method == 'DELETE':
        transaction.delete()
        return HttpResponse(status=204)
