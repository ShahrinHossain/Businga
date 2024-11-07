from django.http import HttpResponse
from django.shortcuts import render

# Create your views here.

def all_users(request):
    return HttpResponse('Returning all users')

from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from django.contrib.auth import authenticate, login, logout
from .serializers import UserSerializer
from django.contrib.auth.models import User
from django.views.decorators.csrf import csrf_exempt
from bkash_webhook import BkashWebhookListener, ValidationError
from bus_app.models import BkashPayload
class RegisterView(APIView):
    def post(self, request):
        serializer = UserSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response({"message": "User registered successfully"}, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class LoginView(APIView):
    def post(self, request):
        username = request.data.get('username')
        password = request.data.get('password')
        user = authenticate(request, username=username, password=password)
        if user is not None:
            login(request, user)
            return Response({"message": "Login successful"}, status=status.HTTP_200_OK)
        return Response({"error": "Invalid credentials"}, status=status.HTTP_400_BAD_REQUEST)

class LogoutView(APIView):
    @csrf_exempt
    def post(self, request):
        logout(request)
        return Response({"message": "Logout successful"}, status=200)


class SampleBkashWebhookLister(APIView):

    authentication_class = ()
    permission_class = ()

    def post(self, request):
        try:
            bkash = BkashWebhookListener(json.loads(request.body))
            response = bkash.bkash_response_process()
            if response is not None:
                # save your payload
                # Remember one thing, their notification payload comes as nested.
                # So you need to convert the message data as dictionary by using json module.
               # example:
               #     json.loads(response.get("Message"))
                BkashPayload.objects.create(
                    payload =  response
                )
            return Response(data = {"Status" : "Sucess"}, status=200)
        except ValidationError as err:
            return Response(data=err.message, status=err.status_code)
