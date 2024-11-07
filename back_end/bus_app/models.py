from django.db import models

class Users(models.Model):
    email = models.EmailField(max_length=30)
    password = models.CharField(max_length=50)

class Person(models.Model):
    first_name = models.CharField(max_length=32)
    last_name = models.CharField(max_length=32)

from django.contrib.auth.models import User
from django.db import models



class CashFlow(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    amount = models.DecimalField(max_digits=10, decimal_places=2)
    type = models.CharField(max_length=50)

    def __str__(self):
        return f"{self.type} - {self.amount}"

class Trip(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    bus = models.ForeignKey('Bus', on_delete=models.CASCADE)
    from_id = models.CharField(max_length=100)
    to_id = models.CharField(max_length=100)
    trip_no = models.CharField(max_length=100)
    route_id = models.ForeignKey('Route', on_delete=models.CASCADE)
    arrival_time = models.TimeField()
    depart_time = models.TimeField()

    def __str__(self):
        return f"Trip {self.trip_no} from {self.from_id} to {self.to_id}"
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
    vehicle_id = models.CharField(max_length=100)
    name = models.CharField(max_length=100)
    location = models.CharField(max_length=100)
    queue_length = models.IntegerField()

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





















class Profile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    # Add any extra fields you want here
    bio = models.TextField(blank=True, null=True)
    phone_number = models.CharField(max_length=15, blank=True, null=True)

    def __str__(self):
        return self.user.username
