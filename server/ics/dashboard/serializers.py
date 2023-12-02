from rest_framework import serializers

from .models import Product, ScanEvent, RFIDGate

# Basic product info
class ProductSerializer(serializers.ModelSerializer):
    class Meta:
        model = Product
        fields = ['id', 'name', 'category', 'rop', 'quantity']

class ScanEventSerializer(serializers.ModelSerializer):
    gate_id = serializers.ReadOnlyField(source='gate.public_id')
    product_id = serializers.ReadOnlyField(source='product.id')
    product_name = serializers.ReadOnlyField(source='product.name')

    class Meta:
        model = ScanEvent
        fields = ['gate_id', 'product_id', 'product_name', 'action', 'quantity', 'time']

class RFIDGateSerializer(serializers.ModelSerializer):
    id = serializers.ReadOnlyField(source='public_id')

    class Meta:
        model = RFIDGate
        fields = ['id', 'scan_action', 'last_connection_time']