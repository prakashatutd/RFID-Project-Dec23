from django.db import models

class Product(models.Model):
    id = models.IntegerField(primary_key=True)
    name = models.CharField(max_length=100)
    description = models.CharField(max_length=500)
    category = models.CharField(max_length=100)
    
    # Assumption is that product dimensions are rounded up to nearest cm
    height = models.PositiveIntegerField(verbose_name="Product height in cm")
    width = models.PositiveIntegerField(verbose_name="Product width in cm")
    depth = models.PositiveIntegerField(verbose_name="Product depth in cm")
    weight = models.DecimalField(max_digits=5,
                                 decimal_places=3,
                                 verbose_name="Product weight in kg")

    quantity = models.PositiveIntegerField()
    min_quantity = models.PositiveIntegerField()
    max_quantity = models.PositiveIntegerField()

    last_update_time = models.DateTimeField()

# Enum representing action taken on product scan
# See https://docs.djangoproject.com/en/4.2/ref/models/fields/#enumeration-types
class ScanAction(models.IntegerChoices):
    RECEIVE = 0
    DISPATCH = 1

class RFIDGate(models.Model):
    # ID of the gate that is displayed on dashboard
    public_id = models.CharField(max_length=32, unique=True)

    # Internal ID that is used by server to identify gates; should not be exposed to user
    internal_id = models.CharField(max_length=32, primary_key=True)

    scan_action = models.IntegerField(choices=ScanAction.choices,
                                      verbose_name="Action taken on scanned products")

    # Time when most recent connection with gate was established
    last_connection_time = models.DateTimeField()

class ScanEvent(models.Model):
    product_id = models.ForeignKey(Product,
                                   null=True,
                                   on_delete=models.SET_NULL,
                                   verbose_name="ID of scanned product")
    
    gate_internal_id = models.ForeignKey(RFIDGate,
                                         null=True,
                                         on_delete=models.SET_NULL,
                                         verbose_name="Internal ID of gate that scanned product")
    
    action = models.IntegerField(choices=ScanAction.choices,
                                      verbose_name="Action taken when product was scanned")
    
    quantity = models.PositiveIntegerField(verbose_name="Number of instances of product scanned")    
    time = models.DateTimeField(verbose_name="Time at which product was scanned")
