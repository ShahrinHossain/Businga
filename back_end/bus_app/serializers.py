from rest_framework import serializers, status
from django.contrib.auth.models import User
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from bus_app.models import Stoppage, Profile, OngoingTrip, Bus, Route, BusCompany, DriverProfile, Photo


class UserSerializer(serializers.ModelSerializer):
    role = serializers.CharField()
    company_id = serializers.CharField(required=False, allow_null=True)
    license_no = serializers.CharField(required=False, allow_null=True)
    company_name = serializers.CharField(required=False, allow_blank=True)

    class Meta:
        model = User
        fields = ['username', 'email', 'password', 'role', 'company_id', 'license_no', 'company_name']
        extra_kwargs = {'password': {'write_only': True}}

    def create(self, validated_data):
        role = validated_data.pop('role')
        company_id = validated_data.pop('company_id', None)  # Now expecting company_id

        user = User.objects.create_user(
            email=validated_data.pop('email'),
            username=validated_data.pop('username'),
            password=validated_data.pop('password')
        )

        if role == 'driver':
            company = BusCompany.objects.get(id=company_id)  # Fetch company by ID
            DriverProfile.create_driver(user, company, **validated_data)

        elif role == 'owner':
            company_name = validated_data.pop('company_name')  # Owners must pass a name
            BusCompany.objects.create(user=user, name=company_name)  # Create company for owner

        Profile.create_profile(user, role)
        return user


class UserInfoSerializer(serializers.ModelSerializer):
    name = serializers.SerializerMethodField()  # Custom field for full name from Profile
    profile = serializers.SerializerMethodField()

    class Meta:
        model = User
        fields = ['id', 'username', 'email', 'name', 'profile']

    def get_name(self, obj):
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


class PhotoSerializer(serializers.ModelSerializer):
    class Meta:
        model = Photo
        fields = ['id', 'user', 'type', 'b64_string']