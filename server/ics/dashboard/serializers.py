from rest_framework import serializers

from .models import Product, ScanEvent

# Basic product info
class ProductSerializer(serializers.ModelSerializer):
    class Meta:
        model = Product
        fields = ['id', 'name', 'category', 'rop', 'quantity']

class ScanEventSerializer(serializers.ModelSerializer):
    class Meta:
        model = ScanEvent
        fields = ['product_id', 'action', 'quantity', 'time']