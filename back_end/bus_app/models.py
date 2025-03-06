from django.contrib.auth.models import User
from django.db import models
from django.db.models import Max


class Profile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, primary_key=True)

    name = models.CharField(max_length=100)
    contact = models.CharField(max_length=15, default="1234567890")

    role = models.CharField(max_length=100)
    balance = models.DecimalField(max_digits=10, decimal_places=2, default=0.00)
    in_route = models.BooleanField(default=False)

    def __str__(self):
        return f"Profile of {self.name}"

    @staticmethod
    def create_profile(user):
        profile = Profile.objects.create(
            user=user,
            name=user.username,
            contact="Unknown",
            role="User",
            balance=0.00,
            in_route=False
        )
        return profile


class CashFlow(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    amount = models.DecimalField(max_digits=10, decimal_places=2)
    type = models.CharField(max_length=50)

    def __str__(self):
        return f"{self.type} - {self.amount}"


class Trip(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    bus = models.ForeignKey('Bus', on_delete=models.CASCADE)
    from_id = models.ForeignKey('Stoppage', on_delete=models.CASCADE, related_name='trip_from_stoppage')
    to_id = models.ForeignKey('Stoppage', on_delete=models.CASCADE, related_name='trip_to_stoppage')
    distance = models.FloatField()  # Distance in kilometers
    fare = models.DecimalField(max_digits=10, decimal_places=2)
    route_id = models.ForeignKey('Route', on_delete=models.CASCADE)
    arrival_time = models.DateTimeField()
    trip_no = models.PositiveIntegerField(unique=True, editable=False)  # Auto-generated
    timestamp = models.DateTimeField(auto_now_add=True)

    def save(self, *args, **kwargs):
        if not self.trip_no:
            last_trip_no = Trip.objects.aggregate(Max('trip_no'))['trip_no__max'] or 0
            self.trip_no = last_trip_no + 1
        super().save(*args, **kwargs)

    def __str__(self):
        return f"Trip {self.trip_no} for user {self.user.username}"


class Transaction(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    trip = models.ForeignKey(Trip, on_delete=models.CASCADE)
    amount = models.DecimalField(max_digits=10, decimal_places=2)
    timestamp = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Transaction {self.id} for {self.amount}"


class Route(models.Model):
    stoppages = models.ManyToManyField('Stoppage')

    def __str__(self):
        return f"Route {self.id}"


class Stoppage(models.Model):
    # id = models.IntegerField(primary_key=True)
    name = models.CharField(max_length=100)
    latitude = models.DecimalField(max_digits=9, decimal_places=6, default=0.0)  # Set default value
    longitude = models.DecimalField(max_digits=9, decimal_places=6, default=0.0)  # Set default value
    queue_length = models.IntegerField(default=0)

    def __str__(self):
        return self.name


class BusCompany(models.Model):
    name = models.CharField(max_length=100)
    owner_id = models.CharField(max_length=100)
    routes = models.ManyToManyField(Route)
    employee_count = models.IntegerField()
    income = models.DecimalField(max_digits=15, decimal_places=2)

    def __str__(self):
        return self.name


class TotalIntake(models.Model):
    company = models.ForeignKey(BusCompany, on_delete=models.CASCADE)
    amount = models.DecimalField(max_digits=15, decimal_places=2)

    def __str__(self):
        return f"Total Intake - {self.amount}"


class Bus(models.Model):
    company = models.ForeignKey('BusCompany', on_delete=models.CASCADE)
    registration_no = models.CharField(max_length=50)
    condition = models.CharField(max_length=50)
    ac_status = models.BooleanField()
    location = models.CharField(max_length=100)

    def __str__(self):
        return self.registration_no


class OngoingTrip(models.Model):
    user = models.ForeignKey(
        'auth.User',
        on_delete=models.CASCADE
    )
    bus_id = models.ForeignKey(  # Renamed from 'bus' to 'bus_id'
        'Bus',
        on_delete=models.CASCADE
    )
    from_id = models.ForeignKey(
        'Stoppage',
        on_delete=models.CASCADE,
        related_name='from_stoppage'
    )
    trip_no = models.PositiveIntegerField(editable=False)  # Auto-generated
    route_id = models.ForeignKey('Route', on_delete=models.CASCADE)
    arrival_time = models.DateTimeField()  # Includes date and time

    def __str__(self):
        return f"Ongoing Trip {self.trip_no} for user {self.user.username}"

    def save(self, *args, **kwargs):
        # Auto-generate `trip_no` if not set
        if not self.trip_no:
            # Filter trips by the same user for user-specific numbering
            last_trip_no = (
                OngoingTrip.objects.filter(user=self.user)
                .aggregate(Max('trip_no'))['trip_no__max'] or 0
            )
            self.trip_no = last_trip_no + 1
        super().save(*args, **kwargs)
