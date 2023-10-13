from django.http import JsonResponse

def api_endpoing(request):
	data = {
		'message: Endpoint created'
	}
	return JsonResponse(data)


