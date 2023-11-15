@echo off

cd .\dashboard
flutter build web || cd .. && exit /b 1
cd ..
python ics\manage.py runserver 0.0.0.0:8000