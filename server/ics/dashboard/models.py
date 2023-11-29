from django.db import models
from pathlib import Path

def product_image_path(instance, filename):
    return f'products/{instance.id}{Path(filename).suffix}'

class Product(models.Model):
    id = models.IntegerField(primary_key=True)
    name = models.CharField(max_length=100)
    category = models.CharField(max_length=100)
    rop = models.PositiveIntegerField(verbose_name='Reorder point', default=0)
    quantity = models.PositiveIntegerField(default=0)

    # Detailed product information
    description = models.CharField(max_length=500,
                                   null=True,
                                   blank=True,
                                   default=None)

    image = models.ImageField(null=True,
                              blank=True,
                              default=None,
                              upload_to=product_image_path)
    
    # Assumption is that product dimensions are rounded up to nearest cm
    height = models.PositiveIntegerField(verbose_name='Height in cm')
    width = models.PositiveIntegerField(verbose_name='Width in cm')
    depth = models.PositiveIntegerField(verbose_name='Depth in cm')
    weight = models.DecimalField(max_digits=6,
                                 decimal_places=3,
                                 verbose_name='Weight in kg')
    
    def needs_resupply(self):
        return self.quantity < self.rop

# Enum representing action taken on product scan
# See https://docs.djangoproject.com/en/4.2/ref/models/fields/#enumeration-types
class ScanAction(models.IntegerChoices):
    RECEIVE = 0
    DISPATCH = 1

class RFIDGate(models.Model):
    public_id = models.CharField(max_length=32,
                                 unique=True,
                                 verbose_name='Gate ID that can be exposed to users')

    internal_id = models.CharField(max_length=32,
                                   primary_key=True,
                                   verbose_name='Gate ID that is used internally to identify gates; should not be exposed to user')

    scan_action = models.IntegerField(choices=ScanAction.choices,
                                      verbose_name='Action taken on scanned products')

    last_connection_time = models.DateTimeField(null=True,
                                                blank=True,
                                                default=None,
                                                verbose_name='Time of most recent connection')

# Represents an event in which an RFID gate scanned one or more instances of a product
class ScanEvent(models.Model):
    product_id = models.ForeignKey(Product,
                                   null=True,
                                   blank=True,
                                   on_delete=models.SET_NULL,
                                   verbose_name='ID of scanned product')
    
    gate_internal_id = models.ForeignKey(RFIDGate,
                                         null=True,
                                         blank=True,
                                         on_delete=models.SET_NULL,
                                         verbose_name='Internal ID of gate that scanned product')
    
    action = models.IntegerField(choices=ScanAction.choices,
                                 verbose_name='Action taken when product was scanned')
    
    quantity = models.PositiveIntegerField(verbose_name='Quantity of product scanned')    
    time = models.DateTimeField(verbose_name='Time at which product was scanned')

# Represents an instance of a product that is currently stored in the warehouse
# Whenever a product instance is scanned, this table should be checked to ensure that
# the instance has not been scanned twice
# Whenever a product instance is scanned out of a warehouse, the corresponding entry should be deleted
class ProductInstance(models.Model):
    # A particular product instance is identified using a
    # - 32-bit product ID
    # - 32-bit serial number
    # The product code is aa 64-bit integer where the upper 32 bits are the product ID
    # and the lower 32 bits are the serial number, thus uniquely identifying a product instance
    code = models.BigIntegerField(primary_key=True, verbose_name='Product code')
    scan_time = models.DateTimeField(verbose_name='Time when product instance was scanned in')

    # Product ID is upper 32 bits
    def get_product_id(self):
        return self.code >> 32
    
    # Serial number is lower 32 bits
    def get_serial_number(self):
        return (self.code << 32) >> 32