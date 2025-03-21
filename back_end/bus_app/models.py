from django.db.models import Max
from django.db import models
from django.contrib.auth.models import User

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
    def create_profile(user, role):
        profile = Profile.objects.create(
            user=user,
            name=user.username,
            contact="Unknown",
            role=role,
            balance=0.00,
            in_route=False
        )
        return profile


class DriverProfile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, primary_key=True)

    name = models.CharField(max_length=100)
    contact_no = models.CharField(max_length=14, default="Unknown")
    license_no = models.CharField(max_length=20)
    company = models.ForeignKey('BusCompany', on_delete=models.CASCADE)  # FK to BusCompany
    date_of_birth = models.DateField()
    on_duty = models.BooleanField(default=False)

    def __str__(self):
        return f"Driver {self.name}"

    @staticmethod
    def create_driver(user, company, on_duty=False, license_no=""):
        driver_profile = DriverProfile.objects.create(
            user=user,
            name=user.username,
            contact_no="Unknown",
            license_no=license_no,
            company=company,  # Now uses FK instead of string
            date_of_birth="2000-01-01",
            on_duty=on_duty
        )
        return driver_profile



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
    timestamp = models.DateTimeField()  # No auto_now_add=True

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


class RouteStoppage(models.Model):
    route = models.ForeignKey('Route', on_delete=models.CASCADE)
    stoppage = models.ForeignKey('Stoppage', on_delete=models.CASCADE)
    order = models.PositiveIntegerField()

    class Meta:
        ordering = ['order']

class Route(models.Model):
    stoppages = models.ManyToManyField('Stoppage', through='RouteStoppage')

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
    id = models.AutoField(primary_key=True)  # Keep the default ID column
    user = models.OneToOneField(User, on_delete=models.CASCADE)  # Link to User
    name = models.CharField(max_length=100)
    employee_count = models.IntegerField(default=0)
    income = models.DecimalField(max_digits=15, decimal_places=2, default=0.00)

    def __str__(self):
        return self.name

    def create_bus_company(user, company_name, employee_count=0, income=0.00):
        bus_company = BusCompany.objects.create(
            user=user,
            name=company_name,
            employee_count=employee_count,
            income=income
        )
        return bus_company


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
        # return self.registration_no
        return f"{self.registration_no} - Driver: {self.driver.name if self.driver else 'Unassigned'}"

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



class Photo(models.Model):
    id = models.AutoField(primary_key=True)
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name="photos")
    type = models.IntegerField()  # type is now an integer
    b64_string = models.TextField()  # Storing base64-encoded string

    def __str__(self):
        return f"Photo {self.id} - Type {self.type} for {self.user.username}"

class OnRoute(models.Model):
    bus_id = models.ForeignKey(Bus, on_delete=models.CASCADE, null=False, blank=False)
    driver_id = models.ForeignKey(DriverProfile, on_delete=models.CASCADE, null=False, blank=False)
    location = models.CharField(max_length=255, null=True, blank=True)
    company_id = models.ForeignKey(BusCompany, on_delete=models.CASCADE, null=True, blank=True)
    paused = models.BooleanField(default=False)
    passengers = models.IntegerField(default=0)

    def __str__(self):
        return f"OnRoute: Bus {self.bus_id.registration_no} | Driver {self.driver_id.name} | Location {self.location}"


class OwnerRequest(models.Model):
    # Personal Information
    full_name = models.CharField(max_length=255)
    phone_number = models.CharField(max_length=15)
    email_address = models.CharField(max_length=255)
    residential_address = models.TextField()
    national_id = models.CharField(max_length=50, unique=True)  # National ID or Passport Number

    # Business Information (if applicable)
    business_name = models.CharField(max_length=255, blank=True, null=True)
    business_registration_number = models.CharField(max_length=50, blank=True, null=True)
    tax_identification_number = models.CharField(max_length=50, blank=True, null=True)  # TIN or GST Number

    # Bus Ownership Details
    brta_certificate_number = models.CharField(max_length=50, unique=True)

    # Certification and Documentation (File Uploads)
    brta_certificate_scan = models.TextField()
    national_id_scan = models.TextField()
    business_registration_scan = models.TextField()

    # Status of the request
    status = models.BooleanField(default=False)

    # Timestamps
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    # Foreign Key to User (if the request is associated with a user account)
    user = models.ForeignKey(User, on_delete=models.CASCADE, null=True, blank=True)

    def __str__(self):
        return f"{self.full_name} - {self.brta_certificate_number} ({self.status})"

    #
    # class Meta:
    #     verbose_name = "Owner Request"
    #     verbose_name_plural = "Owner Requests"