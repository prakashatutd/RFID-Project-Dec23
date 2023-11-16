from django.urls import path

from . import consumers

websocket_urlpatterns = [
    path('ws/dashboard/inventory/', consumers.InventoryConsumer.as_asgi()),
]