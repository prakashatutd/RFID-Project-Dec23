@echo off

cd .\dashboard
flutter build web --base-href=/dashboard/ || cd .. && exit /b 1
cd ..
python ics\manage.py runserver