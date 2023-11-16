from django.contrib import admin

from .models import *

admin.site.register([Product, RFIDGate, ScanEvent, ProductInstance])