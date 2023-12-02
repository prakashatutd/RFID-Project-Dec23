from django_filters.rest_framework import DjangoFilterBackend

from rest_framework.decorators import api_view
from rest_framework.filters import OrderingFilter, SearchFilter
from rest_framework.generics import ListAPIView
from rest_framework.response import Response
from rest_framework.reverse import reverse

from .models import Product, ScanEvent, RFIDGate
from .serializers import ProductSerializer, ScanEventSerializer, RFIDGateSerializer

@api_view(['GET'])
def api_root(request, format=None):
    return Response({
        'products': reverse('product-list', request=request, format=format),
        'history': reverse('scan-events-list', request=request, format=format),
        'gates': reverse('gate-list', request=request, format=format),
    })

class ProductList(ListAPIView):
    queryset = Product.objects.all()
    serializer_class = ProductSerializer

    # Filtering, ordering, and search
    filter_backends = [DjangoFilterBackend, OrderingFilter, SearchFilter]
    filterset_fields = ['category']
    ordering_fields = ['name', 'category', 'rop']
    ordering = 'category'
    search_fields = ['name']

class ScanEventList(ListAPIView):
    queryset = ScanEvent.objects.all()
    serializer_class = ScanEventSerializer

    filter_backends = [DjangoFilterBackend, OrderingFilter, SearchFilter]
    filterset_fields = ['gate_id', 'action']
    ordering_fields = ['time']
    search_fields = ['product_name']

class GateList(ListAPIView):
    queryset = RFIDGate.objects.all()
    serializer_class = RFIDGateSerializer