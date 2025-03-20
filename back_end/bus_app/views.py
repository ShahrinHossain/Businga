import math
from decimal import Decimal

from rest_framework.decorators import api_view, parser_classes
from rest_framework.response import Response
from rest_framework import status
import base64

# from rest_framework.authtoken.models import Token



from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.parsers import MultiPartParser, FormParser
from rest_framework.permissions import AllowAny
from rest_framework.decorators import api_view, parser_classes
from rest_framework.parsers import MultiPartParser, FormParser
from rest_framework.response import Response
from rest_framework import status


# from django.contrib.sites
import requests
from django.conf import settings
from django.http import HttpResponse
from django.shortcuts import get_object_or_404
from django.contrib.auth.models import User
from rest_framework.permissions import IsAuthenticated
from rest_framework.views import APIView
from django.contrib.auth import authenticate, login, logout
from .models import Profile, Stoppage, OngoingTrip, Trip, BusCompany, Photo, Bus, OnRoute
from .serializers import UserSerializer, UserInfoSerializer, BalanceAdjustmentSerializer, StoppageSerializer, \
    ProfileSerializer, OngoingTripSerializer, BusCompanySerializer, BusSerializer, RouteSerializer, \
    DriverProfile, PhotoSerializer, DriverProfileSerializer, OnRouteSerializer

from django.views.decorators.csrf import csrf_exempt
from rest_framework.response import Response
from rest_framework import status
from django.contrib.auth.models import User
from rest_framework_simplejwt.tokens import RefreshToken
from .serializers import UserSerializer
from rest_framework.views import APIView



def all_users(request):
    return HttpResponse('Returning all users')


class RegisterView(APIView):
    authentication_classes = []  # No authentication required for registration
    permission_classes = []  # Allow all users, even unauthenticated

    def post(self, request):
        serializer = UserSerializer(data=request.data)
        if serializer.is_valid():
            user = serializer.save()  # Save the new user instance

            # Generate JWT tokens after successful registration
            refresh = RefreshToken.for_user(user)
            access_token = str(refresh.access_token)

            return Response({
                "message": "User registered successfully",
                "access": access_token,  # Corrected variable name
                "refresh_token": str(refresh),
            }, status=status.HTTP_201_CREATED)

        print(serializer.errors)  # Log errors for debugging
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)



class LogoutView(APIView):
    # @csrf_exempt
    def get(self, request):
        logout(request)
        return Response({"message": "Logout successful"}, status=200)


class CurrentUserInfoView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        serializer = UserInfoSerializer(request.user)
        return Response(serializer.data, status=status.HTTP_200_OK)

class BusCompanyView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        try:
            bus_company = BusCompany.objects.get(user=request.user)
            serializer = BusCompanySerializer(bus_company)  # Pass BusCompany instance
            return Response(serializer.data, status=status.HTTP_200_OK)
        except BusCompany.DoesNotExist:
            return Response({"error": "Bus company not found"}, status=status.HTTP_404_NOT_FOUND)

class DriverListView(APIView):
    permission_classes = [IsAuthenticated]  # Ensure the user is authenticated

    def get(self, request, company_id):
        # Fetch drivers by matching the company ID directly
        drivers = DriverProfile.objects.filter(company=company_id)

        # If no drivers found, return an error
        if not drivers.exists():
            return Response({"error": "No drivers found for the given company."}, status=status.HTTP_404_NOT_FOUND)

        # Serialize the driver data
        driver_serializer = DriverProfileSerializer(drivers, many=True)

        return Response(driver_serializer.data, status=status.HTTP_200_OK)

class CurrentDriverInfoView(APIView):
    permission_classes = [IsAuthenticated]  # Ensure the user is authenticated

    def get(self, request, user_id):
        # Fetch drivers by matching the company ID directly
        driver = DriverProfile.objects.filter(user_id=user_id).first()

        # If no drivers found, return an error
        # if not driver.exists():
        #     return Response({"error": "No driver found."}, status=status.HTTP_404_NOT_FOUND)

        # Serialize the driver data
        driver_serializer = DriverProfileSerializer(driver)

        return Response(driver_serializer.data, status=status.HTTP_200_OK)

class BusListView(APIView):
    permission_classes = [IsAuthenticated]  # Ensure the user is authenticated

    def get(self, request, company_id):
        # Fetch buses by matching the company ID
        buses = Bus.objects.filter(company=company_id)

        # If no buses found, return an error
        if not buses.exists():
            return Response({"error": "No buses found for the given company."}, status=status.HTTP_404_NOT_FOUND)

        # Serialize the bus data
        bus_serializer = BusSerializer(buses, many=True)

        return Response(bus_serializer.data, status=status.HTTP_200_OK)


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


class AddToBalanceView(APIView):
    permission_classes = [IsAuthenticated]  # Ensure the user is authenticated

    def post(self, request):
        # Check if the user is authenticated
        user = request.user

        # Extract the amount from the request data
        amount = request.data.get('amount')

        # Validate the amount
        if amount is None:
            return Response({"error": "Amount is required"}, status=status.HTTP_400_BAD_REQUEST)

        try:
            amount = Decimal(amount)  # Convert amount to Decimal for proper arithmetic
        except (ValueError, InvalidOperation):
            return Response({"error": "Invalid amount format"}, status=status.HTTP_400_BAD_REQUEST)

        # Ensure the amount is greater than or equal to 0
        if amount < 0:
            return Response({"error": "Amount must be greater than or equal to 0"}, status=status.HTTP_400_BAD_REQUEST)

        # Retrieve the user's profile
        profile = get_object_or_404(Profile, user=user)

        # Add the amount to the user's balance
        profile.balance += amount
        profile.save()

        return Response({
            "message": "Balance updated successfully",
            "balance": str(profile.balance)  # Convert balance to string to avoid Decimal format issues
        }, status=status.HTTP_200_OK)


class StoppageCreateView(APIView):
    authentication_classes = []  # No authentication required for registration
    permission_classes = [] # Allow all users, even unauthenticated
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
    # permission_classes = [IsAuthenticated]
    def get(self, request):
        logout(request)
        return Response({"message": "Logout successful"}, status=200)

    def put(self, request):
        # data = {"message": "Hello from Django"}
        # return Response(data, status=status.HTTP_200_OK)
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

    @csrf_exempt
    def post(self, request):
        # Get the user's profile
        print(request.data)

        profile = Profile.objects.get(user=request.user)

        # Check if the user's balance is 0 or negative
        if profile.balance <= 0:
            return Response({"error": "Insufficient balance. Please top up before starting a trip."},
                            status=status.HTTP_400_BAD_REQUEST)

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
        closest_stoppage = Stoppage.objects.first()
        min_distance = float('inf')

        for stoppage in Stoppage.objects.all():
            distance = math.sqrt(
                (float(stoppage.latitude) - latitude) ** 2 +
                (float(stoppage.longitude) - longitude) ** 2
            )
            if distance < min_distance:
                min_distance = distance
                closest_stoppage = stoppage

        if not closest_stoppage:
            return Response({"error": "No stoppages found."}, status=status.HTTP_404_NOT_FOUND)

        # Include the authenticated user and closest stoppage in the request data
        data = request.data.copy()  # Create a mutable copy of the request data
        data['from_id'] = closest_stoppage.id
        data['user'] = request.user.id  # Add the authenticated user's ID

        # Use the serializer to validate and save the data
        serializer = OngoingTripSerializer(data=data)
        if serializer.is_valid():
            serializer.save()  # trip_no will be auto-generated here

            # Update user's Profile to set in_route = True
            profile.in_route = True
            profile.save(update_fields=['in_route'])

            return Response(serializer.data, status=status.HTTP_201_CREATED)

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


def calculate_fare(distance):
    return max(10.0, distance * 2.45)


def decimal_to_float(obj):
    """ Recursively convert Decimals to floats in a JSON-serializable format. """
    if isinstance(obj, Decimal):
        return float(obj)
    elif isinstance(obj, dict):
        return {key: decimal_to_float(value) for key, value in obj.items()}
    elif isinstance(obj, list):
        return [decimal_to_float(item) for item in obj]
    return obj



class FinishTripView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        latitude = request.data.get("latitude")
        longitude = request.data.get("longitude")
        print("HIT")

        # Validate inputs
        if latitude is None or longitude is None:
            return Response({"error": "Latitude and longitude are required."}, status=status.HTTP_400_BAD_REQUEST)

        try:
            latitude = float(latitude)
            longitude = float(longitude)
        except ValueError:
            return Response({"error": "Invalid latitude or longitude format."}, status=status.HTTP_400_BAD_REQUEST)

        # Find the last ongoing trip for the authenticated user
        ongoing_trip = OngoingTrip.objects.filter(user=request.user).last()
        if not ongoing_trip:
            return Response({"error": "No ongoing trip found for the user."}, status=status.HTTP_404_NOT_FOUND)

        # Get the stoppage details from the last ongoing trip
        from_stoppage = ongoing_trip.from_id

        # Find the nearest stoppage to the provided latitude and longitude
        nearest_stoppage = None
        min_distance = float("inf")

        for stoppage in Stoppage.objects.all():
            distance = math.sqrt(
                (float(stoppage.latitude) - latitude) ** 2 +
                (float(stoppage.longitude) - longitude) ** 2
            )
            if distance < min_distance:
                min_distance = distance
                nearest_stoppage = stoppage

        if not nearest_stoppage:
            return Response({"error": "No stoppages found to match the destination."}, status=status.HTTP_404_NOT_FOUND)

        print(f"{from_stoppage.latitude} {from_stoppage.longitude}")
        print(f"{nearest_stoppage.latitude} {nearest_stoppage.longitude}")

        # Make a request to Google Maps Routes API (New Method)
        google_maps_api_key = settings.GOOGLE_MAPS_API_KEY
        google_routes_url = "https://routes.googleapis.com/directions/v2:computeRoutes"
        payload = {
            "origin": {
                "location": {
                    "latLng": {
                        "latitude": decimal_to_float(from_stoppage.latitude),
                        "longitude": decimal_to_float(from_stoppage.longitude)
                    }
                }
            },
            "destination": {
                "location": {
                    "latLng": {
                        "latitude": decimal_to_float(nearest_stoppage.latitude),
                        "longitude": decimal_to_float(nearest_stoppage.longitude)
                    }
                }
            },
            "travelMode": "DRIVE"
        }

        headers = {
            "Content-Type": "application/json",
            "X-Goog-Api-Key": settings.GOOGLE_MAPS_API_KEY,
            "X-Goog-FieldMask": "routes.distanceMeters,routes.duration"
        }

        #
        try:
            response = requests.post(google_routes_url, json=payload, headers=headers)
            response.raise_for_status()
            routes_data = response.json()
            print(routes_data)

            # Check if routes are found and handle the case where duration is 0s
            print(routes_data.get("status"))
            if "routes" in routes_data and routes_data["routes"]:
                route = routes_data["routes"][0]
                print(route)
                # Check if the duration is 0s
                if route["duration"] == "0s":
                    road_distance = 0  # Set distance to 0 if duration is 0s
                else:
                    road_distance = route["distanceMeters"] / 1000  # Convert meters to km
            else:
                return Response(
                    {"error": "No valid route found for the specified locations."},
                    status=status.HTTP_404_NOT_FOUND
                )

        except requests.RequestException as e:
            return Response({"error": "Failed to fetch route data", "details": str(e)},
                            status=status.HTTP_500_INTERNAL_SERVER_ERROR)

        # Calculate the fare
        fare = calculate_fare(road_distance)

        # Deduct fare from the user's balance
        profile = Profile.objects.get(user=request.user)
        fare_decimal = Decimal(fare)

        # Perform the subtraction
        profile.balance -= fare_decimal
        profile.in_route = False
        profile.save(update_fields=["balance", "in_route"])

        # Add entry to Trip table
        trip = Trip.objects.create(
            user=ongoing_trip.user,
            bus=ongoing_trip.bus_id,
            from_id=from_stoppage,
            to_id=nearest_stoppage,
            distance=road_distance,
            route_id=ongoing_trip.route_id,
            arrival_time=ongoing_trip.arrival_time,
            fare=fare,
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
                    "fare": trip.fare,
                    "route_id": trip.route_id.id,
                    "arrival_time": trip.arrival_time,
                    "trip_no": trip.trip_no,
                    "timestamp": trip.timestamp,
                },
            },
            status=status.HTTP_201_CREATED,
        )

class AddBusView(APIView):
    permission_classes = []
    authentication_classes = []  # No authentication required for registration
    def post(self, request):
        # print(request.data)
        # Extract data from request
        registration_no = request.data.get('registration_no')
        condition = request.data.get('condition')
        ac_status = request.data.get('ac_status')
        location = request.data.get('location')
        company_id = request.data.get('company_id')

        # Validate company exists
        try:
            company = BusCompany.objects.get(id=company_id)
        except BusCompany.DoesNotExist:
            return Response({"error": "Bus company not found"}, status=status.HTTP_400_BAD_REQUEST)

        # Create the bus object
        bus_data = {
            'registration_no': registration_no,
            'condition': condition,
            'ac_status': ac_status,
            'location': location,
            'company': company.id
        }

        serializer = BusSerializer(data=bus_data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class AddRouteView(APIView):
    permission_classes = []
    authentication_classes = []

    def post(self, request):
        # Extract stoppages list from request
        stoppages_ids = request.data.get('stoppages')  # List of stoppage IDs
        if not stoppages_ids:
            return Response({"error": "Stoppages are required."}, status=status.HTTP_400_BAD_REQUEST)

        # Validate that all stoppages exist
        stoppages = []
        for stoppage_id in stoppages_ids:
            try:
                stoppage = Stoppage.objects.get(id=stoppage_id)
                stoppages.append(stoppage.id)
            except Stoppage.DoesNotExist:
                return Response({"error": f"Stoppage with ID {stoppage_id} not found."},
                                status=status.HTTP_400_BAD_REQUEST)

        # Create the route
        route_data = {
            'stoppages': stoppages  # ManyToMany relation will handle adding multiple stoppages
        }
        # print(route_data)
        # print('here')

        serializer = RouteSerializer(data=route_data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class AddBusCompanyView(APIView):
    def post(self, request, *args, **kwargs):
        # Deserialize the request data using the serializer
        serializer = BusCompanySerializer(data=request.data)

        if serializer.is_valid():
            # Save the bus company to the database
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class AddPhotoView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        # Get user from request
        user = request.user

        # Ensure a file is provided
        photo_file = request.FILES.get('file')
        photo_type = request.data.get('type')

        if not photo_file or not photo_type:
            return Response({"error": "File and type are required."}, status=status.HTTP_400_BAD_REQUEST)

        # Read the file and convert it to Base64
        try:
            file_data = photo_file.read()
            b64_string = base64.b64encode(file_data).decode('utf-8')
        except Exception as e:
            return Response({"error": f"Error processing file: {str(e)}"}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

        # Create the photo object in the database
        photo = Photo.objects.create(user=user, type=photo_type, b64_string=b64_string)

        # Serialize and return the response
        serializer = PhotoSerializer(photo)
        return Response(serializer.data, status=status.HTTP_201_CREATED)


class UpdateFirstPhotoView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        user = request.user

        # Ensure a file and type are provided
        photo_file = request.FILES.get('file')
        photo_type = request.data.get('type')

        if not photo_file or not photo_type:
            return Response({"error": "File and type are required."}, status=status.HTTP_400_BAD_REQUEST)

        # Get the first photo of the given type for the user
        photo = Photo.objects.filter(user=user, type=photo_type).first()

        if not photo:
            return Response({"error": "No photo of this type found."}, status=status.HTTP_404_NOT_FOUND)

        # Read the file and convert it to Base64
        try:
            file_data = photo_file.read()
            b64_string = base64.b64encode(file_data).decode('utf-8')
        except Exception as e:
            return Response({"error": f"Error processing file: {str(e)}"}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

        # Update the photo's base64 string
        photo.b64_string = b64_string
        photo.save()

        # Serialize and return the response
        serializer = PhotoSerializer(photo)
        return Response(serializer.data, status=status.HTTP_200_OK)


class GetPhotoView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, photo_type):
        user = request.user

        # Fetch the first photo of the specified type for the user
        photo = Photo.objects.filter(user=user, type=photo_type).first()
        if not photo:
            return Response({"error": "No photo found."}, status=status.HTTP_404_NOT_FOUND)

        try:
            # Decode Base64 back to image bytes
            image_data = base64.b64decode(photo.b64_string)

            # Return the image as an HTTP response
            response = HttpResponse(image_data, content_type="image/png")  # Adjust content type as needed
            response["Content-Disposition"] = f'inline; filename="photo_{photo_type}.png"'
            return response

        except Exception as e:
            return Response({"error": f"Error decoding image: {str(e)}"}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


class AddOnRouteView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        # Extract data from request
        bus_id = request.data.get('bus_id')
        driver_id = request.data.get('driver_id')
        location = request.data.get('location')
        company_id = request.data.get('company_id')

        # Ensure bus_id and driver_id are provided
        if not bus_id or not driver_id:
            return Response({"error": "Bus ID and Driver ID are required"}, status=status.HTTP_400_BAD_REQUEST)

        # Create the OnRoute object
        on_route_data = {
            'bus_id': bus_id,
            'driver_id': driver_id,
            'location': location if location else None,  # Set location to None if it's empty
            'company_id': company_id
        }

        # Validate the data with the serializer
        serializer = OnRouteSerializer(data=on_route_data)

        if serializer.is_valid():
            # Save the OnRoute entry
            serializer.save()

            # **Update Profile's in_route field**
            profile = get_object_or_404(Profile, user_id=driver_id)
            profile.in_route = True
            profile.save()

            return Response(serializer.data, status=status.HTTP_201_CREATED)

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class FindNearestStoppage(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        latitude = request.query_params.get("latitude")
        longitude = request.query_params.get("longitude")
        print("HIT")

        # Validate inputs
        if latitude is None or longitude is None:
            return Response({"error": "Latitude and longitude are required."}, status=status.HTTP_400_BAD_REQUEST)

        try:
            latitude = float(latitude)
            longitude = float(longitude)
        except ValueError:
            return Response({"error": "Invalid latitude or longitude format."}, status=status.HTTP_400_BAD_REQUEST)

        # Find the nearest stoppage to the provided latitude and longitude
        nearest_stoppage = None
        min_distance = float("inf")

        for stoppage in Stoppage.objects.all():
            distance = math.sqrt(
                (float(stoppage.latitude) - latitude) ** 2 +
                (float(stoppage.longitude) - longitude) ** 2
            )
            if distance < min_distance:
                min_distance = distance
                nearest_stoppage = stoppage

        if not nearest_stoppage:
            return Response({"error": "No stoppages found to match the destination."}, status=status.HTTP_404_NOT_FOUND)

        print(latitude, longitude)
        print(nearest_stoppage.latitude , nearest_stoppage.longitude)


        return Response(
            {
                "message": "Nearest stoppage found.",
                "stoppage": {
                    "id": nearest_stoppage.id,
                    "name": nearest_stoppage.name,
                    "latitude": nearest_stoppage.latitude,
                    "longitude": nearest_stoppage.longitude,
                    "queue_length": nearest_stoppage.queue_length,
                },
            },
            status=status.HTTP_200_OK,
        )


class CurrentTripView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        # Get the user's profile
        profile = Profile.objects.get(user=request.user)

        # Check if the user is currently in a trip
        if not profile.in_route:
            return Response({"error": "User is not currently in a trip."}, status=status.HTTP_404_NOT_FOUND)

        # Get the ongoing trip details
        ongoing_trip = OngoingTrip.objects.filter(user=request.user).last()

        return Response(
            {
                "message": "User is currently in a trip.",
                "trip": {
                    "user": ongoing_trip.user.id,
                    "bus": ongoing_trip.bus_id.id,
                    "from_id": ongoing_trip.from_id.id,
                    "route_id": ongoing_trip.route_id.id,
                    "arrival_time": ongoing_trip.arrival_time,
                    "trip_no": ongoing_trip.trip_no,
                },
            },
            status=status.HTTP_200_OK,
        )

class ListLastTrips(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        # Get the user's profile
        try:
            profile = Profile.objects.get(user=request.user)
        except Profile.DoesNotExist:
            return Response({"error": "Profile not found."}, status=status.HTTP_404_NOT_FOUND)


        # Get the last 10 trips for the user, ordered by timestamp (most recent first)
        last_trips = Trip.objects.filter(user=request.user).order_by('-timestamp')[:10]

        # Serialize the trip data
        trips_data = []
        for trip in last_trips:
            trips_data.append({
                "user": trip.user.id,
                "bus": trip.bus.id,
                "from_stoppage": {
                    "id": trip.from_id.id,
                    "name": trip.from_id.name,
                    "latitude": trip.from_id.latitude,
                    "longitude": trip.from_id.longitude,
                },
                "to_stoppage": {
                    "id": trip.to_id.id,
                    "name": trip.to_id.name,
                    "latitude": trip.to_id.latitude,
                    "longitude": trip.to_id.longitude,
                },
                "distance": trip.distance,  # Distance in kilometers
                "fare": str(trip.fare),  # Convert Decimal to string for JSON serialization
                "route": {
                    "id": trip.route_id.id,
                },
                "arrival_time": trip.arrival_time.isoformat(),  # Convert DateTime to ISO format
                "trip_no": trip.trip_no,
                "timestamp": trip.timestamp.isoformat(),  # Convert DateTime to ISO format
            })

        return Response(
            {
                "message": "Last 10 trips.",
                "trips": trips_data,
            },
            status=status.HTTP_200_OK,
        )