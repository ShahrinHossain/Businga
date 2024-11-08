from rest_framework import serializers
from django.contrib.auth.models import User


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['username', 'email', 'password']
        extra_kwargs = {'password': {'write_only': True}}

    def create(self, validated_data):
        user = User(
            email=validated_data['email'],
            username=validated_data['username']
        )
        user.set_password(validated_data['password'])
        user.save()
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
            }
        return None