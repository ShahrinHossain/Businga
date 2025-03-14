from rest_framework import serializers, status
from django.contrib.auth.models import User
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView
from django.utils.timezone import now

from bus_app.models import Stoppage, Profile, OngoingTrip, Bus, Route, BusCompany, Trip


# class UserSerializer(serializers.ModelSerializer):
#     class Meta:
#         model = User
#         fields = ['username', 'email', 'password']
#         extra_kwargs = {'password': {'write_only': True}}
#
#     def create(self, validated_data):
#         user = User(
#             email=validated_data['email'],
#             username=validated_data['username'],
#         )
#         user.set_password(validated_data['password'])
#         user.save()
#         return user

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

    def create(self, validated_data):
        validated_data['arrival_time'] = now()  # Set arrival_time to the current system time
        return super().create(validated_data)


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

from rest_framework import serializers
from .models import Trip

class TripSerializer(serializers.ModelSerializer):
    from_stoppage = serializers.CharField(source='from_id.name', read_only=True)
    to_stoppage = serializers.CharField(source='to_id.name', read_only=True)

    class Meta:
        model = Trip
        fields = ('id', 'bus', 'from_stoppage', 'to_stoppage', 'distance', 'fare', 'arrival_time', 'trip_no', 'timestamp')
