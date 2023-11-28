from rest_framework import serializers

from .models import Product

# Basic product info
class ProductSerializer(serializers.ModelSerializer):
    class Meta:
        model = Product
        fields = ['id', 'name', 'category', 'rop', 'quantity']