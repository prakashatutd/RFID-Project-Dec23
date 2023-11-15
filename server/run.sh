#!/bin/sh

cd ./dashboard
flutter build web || exit 1
cd ..
python ics/manage.py runserver 0.0.0.0:8000