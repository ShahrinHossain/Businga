from rest_framework import serializers, status
from django.contrib.auth.models import User
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from bus_app.models import Stoppage, Profile, OngoingTrip, Bus, Route, BusCompany, DriverTrip, DriverProfile



class UserSerializer(serializers.ModelSerializer):
    role = serializers.CharField()  # Add role field

    class Meta:
        model = User
        fields = ['username', 'email', 'password', 'role']  # Add role to fields
        extra_kwargs = {'password': {'write_only': True}}

    def create(self, validated_data):
        # Extract role
        role = validated_data.pop('role')  # Remove role from validated data

        # Create user
        user = User(
            email=validated_data['email'],
            username=validated_data['username'],
        )
        user.set_password(validated_data['password'])
        user.save()

        # Create Profile and assign the role
        Profile.create_profile(user, role)

        return user

class UserInfoSerializer(serializers.ModelSerializer):
    name = serializers.SerializerMethodField()  # Custom field for full name from Profile
    profile = serializers.SerializerMethodField()

    class Meta:
        model = User
        fields = ['id', 'username', 'email', 'name', 'profile']

    def get_name(self, obj):
        # Using the name field from the associated Profile
        if hasattr(obj, 'profile'):
            return obj.profile.name
        return None

    def get_profile(self, obj):
        if hasattr(obj, 'profile'):
            return {
                "contact": obj.profile.contact,
                "role": obj.profile.role,
                "balance": obj.profile.balance,
                "in_route": obj.profile.in_route
            }
        return None

class DriverSerializer(serializers.ModelSerializer):
    date_of_birth = serializers.DateField()  # Add date of birth field
    region = serializers.CharField()  # Add region field

    class Meta:
        model = User
        fields = ['username', 'email', 'password', 'date_of_birth', 'region']
        extra_kwargs = {'password': {'write_only': True}}  # Hide password in responses

    def create(self, validated_data):
        # Extract additional fields
        date_of_birth = validated_data.pop('date_of_birth')
        region = validated_data.pop('region')

        # Create user
        user = User(
            email=validated_data['email'],
            username=validated_data['username'],
        )
        user.set_password(validated_data['password'])
        user.save()

        # Create DriverProfile and assign additional fields
        DriverProfile.create_driver(user, date_of_birth, region)

        return user


class DriverInfoSerializer(serializers.ModelSerializer):
    name = serializers.SerializerMethodField()  # Custom field for full name
    profile = serializers.SerializerMethodField()

    class Meta:
        model = User
        fields = ['id', 'username', 'email', 'name', 'profile']

    def get_name(self, obj):
        if hasattr(obj, 'driverprofile'):
            return obj.driverprofile.name
        return None

    def get_profile(self, obj):
        if hasattr(obj, 'driverprofile'):
            return {
                "date_of_birth": obj.driverprofile.date_of_birth,
                "region": obj.driverprofile.region
            }
        return None



from rest_framework import serializers
from django.contrib.auth.models import User
from .models import DriverProfile, VerifiedDriverProfile  # Ensure VerifiedDriverProfile exists in models.py

# ------------------- 🚗 Verified Driver Serializer -------------------
from rest_framework import serializers
from .models import VerifiedDriverProfile

# ------------------- 🚗 Serializer for Verified Driver (Independent) -------------------
class VerifiedDriverSerializer(serializers.ModelSerializer):
    class Meta:
        model = VerifiedDriverProfile  # ✅ Uses separate table
        fields = ['username', 'image_1', 'image_2', 'image_3']

    def create(self, validated_data):
        return VerifiedDriverProfile.objects.create(**validated_data)



# ------------------- 🚖 Verified Driver Info Serializer -------------------
class VerifiedDriverInfoSerializer(serializers.ModelSerializer):
    username = serializers.CharField()  # ✅ Uses `username` directly
    images = serializers.SerializerMethodField()  # ✅ Returns images in a structured format

    class Meta:
        model = VerifiedDriverProfile
        fields = ['username', 'images']

    def get_images(self, obj):
        return {
            "image_1": obj.image_1.url if obj.image_1 else None,
            "image_2": obj.image_2.url if obj.image_2 else None,
            "image_3": obj.image_3.url if obj.image_3 else None,
        }




class BalanceAdjustmentSerializer(serializers.Serializer):
    id = serializers.IntegerField()
    amount = serializers.DecimalField(max_digits=10, decimal_places=2)

class StoppageSerializer(serializers.ModelSerializer):
    class Meta:
        model = Stoppage
        fields = ['name', 'latitude', 'longitude', 'queue_length']

class ProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = Profile
        fields = ['name', 'contact', 'role', 'balance']

class OngoingTripSerializer(serializers.ModelSerializer):
    trip_no = serializers.ReadOnlyField()  # Auto-generated field

    class Meta:
        model = OngoingTrip
        fields = ['user', 'bus_id', 'from_id', 'trip_no', 'route_id', 'arrival_time']

class BusSerializer(serializers.ModelSerializer):
    class Meta:
        model = Bus
        fields = ['id', 'registration_no', 'condition', 'ac_status', 'location', 'company']

class RouteSerializer(serializers.ModelSerializer):
    class Meta:
        model = Route
        fields = ['stoppages']

class BusCompanySerializer(serializers.ModelSerializer):
    class Meta:
        model = BusCompany
        fields = ['id', 'name', 'owner_id', 'employee_count', 'income']

