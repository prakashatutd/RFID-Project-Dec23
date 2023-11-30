from django.urls import path
from rest_framework.urlpatterns import format_suffix_patterns

from . import views

urlpatterns = format_suffix_patterns([
    path('', views.api_root),
    path('products/', views.ProductList.as_view(), name='product-list'),
    path('history/', views.ScanEventList.as_view(), name='scan-events-list'),
])