import math

from django.conf import settings
# from django.contrib.sites
import requests
from django.http import HttpResponse
from django.shortcuts import render, get_object_or_404
from rest_framework.permissions import IsAuthenticated
import geopy
from .models import Profile, Stoppage, OngoingTrip, Trip


# Create your views here.

def all_users(request):
    return HttpResponse('Returning all users')

from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from django.contrib.auth import authenticate, login, logout
from .serializers import UserSerializer, UserInfoSerializer, BalanceAdjustmentSerializer, StoppageSerializer, \
    ProfileSerializer, OngoingTripSerializer
from django.contrib.auth.models import User
from django.views.decorators.csrf import csrf_exempt
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
        print(username)
        print(password)
        user = authenticate(request, username=username, password=password)
        if user is not None:
            login(request, user)
            return Response({"message": "Login successful"}, status=status.HTTP_200_OK)
        return Response({"error": "Invalid credentials"}, status=status.HTTP_400_BAD_REQUEST)


class LogoutView(APIView):
    # @csrf_exempt
    def get(self, request):
        logout(request)
        return Response({"message": "Logout successful"}, status=200)


class CurrentUserView(APIView):
    def get(self, request):
        if request.user.is_authenticated:
            return Response({"username": request.user.username}, status=status.HTTP_200_OK)
        return Response({"username": None}, status=status.HTTP_200_OK)

from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
@api_view(['GET', 'POST'])
def example_view(request):
    if request.method == 'GET':
        data = {"message": "Hello from Django"}
        return Response(data, status=status.HTTP_200_OK)
    elif request.method == 'POST':
        received_data = request.data
        return Response({"received_data": received_data}, status=status.HTTP_201_CREATED)

class CurrentUserInfoView(APIView):
    def get(self, request):
        if request.user.is_authenticated:
            serializer = UserInfoSerializer(request.user)
            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response({"error": "User not authenticated"}, status=status.HTTP_401_UNAUTHORIZED)


class AdjustBalanceView(APIView):
    def post(self, request):
        serializer = BalanceAdjustmentSerializer(data=request.data)

        if serializer.is_valid():
            user_id = serializer.validated_data['id']
            amount = serializer.validated_data['amount']

            profile = get_object_or_404(Profile, user__id=user_id)

            if amount < 0 and profile.balance + amount < 0:
                return Response({"error": "Insufficient balance"}, status=status.HTTP_400_BAD_REQUEST)

            profile.balance += amount
            profile.save()

            return Response({
                "message": "Balance updated successfully",
                "balance": profile.balance
            }, status=status.HTTP_200_OK)

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class StoppageCreateView(APIView):
    def post(self, request):
        serializer = StoppageSerializer(data=request.data)

        if serializer.is_valid():
            serializer.save()
            return Response({"message": "Stoppage created successfully"}, status=status.HTTP_201_CREATED)

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class StoppageListView(APIView):
    def get(self, request):
        stoppages = Stoppage.objects.all()
        serializer = StoppageSerializer(stoppages, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)


class UpdateProfileView(APIView):
    permission_classes = [IsAuthenticated]

    def put(self, request):
        try:
            profile = Profile.objects.get(user=request.user)
        except Profile.DoesNotExist:
            return Response({"error": "Profile not found"}, status=status.HTTP_404_NOT_FOUND)

        serializer = ProfileSerializer(profile, data=request.data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class AddOngoingTripView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        # Extract latitude and longitude from the request data
        latitude = request.data.get('latitude')
        longitude = request.data.get('longitude')

        if latitude is None or longitude is None:
            return Response({"error": "Latitude and longitude are required."}, status=status.HTTP_400_BAD_REQUEST)

        try:
            latitude = float(latitude)
            longitude = float(longitude)
        except ValueError:
            return Response({"error": "Invalid latitude or longitude format."}, status=status.HTTP_400_BAD_REQUEST)

        # Find the closest stoppage
        closest_stoppage = None
        min_distance = float('inf')

        for stoppage in Stoppage.objects.all():
            distance = math.sqrt(
                (stoppage.latitude - latitude) ** 2 +
                (stoppage.longitude - longitude) ** 2
            )
            if distance < min_distance:
                min_distance = distance
                closest_stoppage = stoppage

        if not closest_stoppage:
            return Response({"error": "No stoppages found."}, status=status.HTTP_404_NOT_FOUND)

        # Add the closest stoppage ID to the request data
        request.data['from_id'] = closest_stoppage.id

        # Use the serializer to validate and save the data
        serializer = OngoingTripSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()  # trip_no will be auto-generated here
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class FinishTripView(APIView):
    def post(self, request):
        user_id = request.data.get('user_id')
        latitude = request.data.get('latitude')
        longitude = request.data.get('longitude')

        # Validate inputs
        if not user_id or latitude is None or longitude is None:
            return Response({"error": "User ID, latitude, and longitude are required."}, status=status.HTTP_400_BAD_REQUEST)

        try:
            latitude = float(latitude)
            longitude = float(longitude)
        except ValueError:
            return Response({"error": "Invalid latitude or longitude format."}, status=status.HTTP_400_BAD_REQUEST)

        # Find the ongoing trip for the user
        try:
            ongoing_trip = OngoingTrip.objects.get(user_id=user_id)
        except OngoingTrip.DoesNotExist:
            return Response({"error": "No ongoing trip found for the user."}, status=status.HTTP_404_NOT_FOUND)


        from_stoppage = ongoing_trip.from_id
        from_coordinates = (from_stoppage.latitude, from_stoppage.longitude)
        to_coordinates = (latitude, longitude)


        google_maps_api_key = settings.GOOGLE_MAPS_API_KEY
        google_maps_url = "https://maps.googleapis.com/maps/api/directions/json"
        params = {
            "origin": f"{from_stoppage.latitude},{from_stoppage.longitude}",
            "destination": f"{latitude},{longitude}",
            "key": google_maps_api_key
        }

        response = requests.get(google_maps_url, params=params)

        if response.status_code != 200:
            return Response({"error": "Error calculating road distance using Google Maps API."}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

        directions_data = response.json()

        if directions_data["status"] != "OK":
            return Response({"error": "No route found for the specified locations."}, status=status.HTTP_404_NOT_FOUND)


        road_distance = directions_data["routes"][0]["legs"][0]["distance"]["value"] / 1000


        nearest_stoppage = None
        min_distance = float('inf')
        for stoppage in Stoppage.objects.all():
            stoppage_coords = (stoppage.latitude, stoppage.longitude)
            current_distance = geopy.distance.geodesic(to_coordinates, stoppage_coords).km
            if current_distance < min_distance:
                min_distance = current_distance
                nearest_stoppage = stoppage

        if not nearest_stoppage:
            return Response({"error": "No stoppages found to match the destination."}, status=status.HTTP_404_NOT_FOUND)

        # Add entry to Trip table
        trip = Trip.objects.create(
            user=ongoing_trip.user,
            bus=ongoing_trip.bus,
            from_id=from_stoppage,
            to_id=nearest_stoppage,
            distance=road_distance,
            route_id=ongoing_trip.route_id,
            arrival_time=ongoing_trip.arrival_time
        )

        # Remove the ongoing trip entry
        ongoing_trip.delete()

        return Response(
            {
                "message": "Trip finished successfully.",
                "trip": {
                    "user": trip.user.id,
                    "bus": trip.bus.id,
                    "from_id": trip.from_id.id,
                    "to_id": trip.to_id.id,
                    "distance": trip.distance,
                    "route_id": trip.route_id.id,
                    "arrival_time": trip.arrival_time,
                    "trip_no": trip.trip_no,
                    "timestamp": trip.timestamp
                }
            },
            status=status.HTTP_201_CREATED
        )