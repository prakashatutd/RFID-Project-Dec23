from django.conf import settings
from django.conf.urls.static import static
from django.contrib import admin
from django.urls import path
from django.views.static import serve

SERVER_DIR = settings.BASE_DIR.parent
DASHBOARD_DIR = (SERVER_DIR / 'dashboard/build/web').resolve()

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', serve, { 'path' : 'index.html', 'document_root' : DASHBOARD_DIR }),
    path('<path>/', serve, { 'document_root' : DASHBOARD_DIR }),
] + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
