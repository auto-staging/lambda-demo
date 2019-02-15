package main

import (
	"github.com/auto-staging/lambda-demo/controller"
	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

// Handler is the main function called by lambda.Start, it redirects the request to the matching controller by resource and http method.
// Since the Lambda function is called through API Gateway it uses APIGatewayProxyRequest as parameter
// to get information about the request (containing ressource, method and much more) and APIGatewayProxyResponse as return value (including http code and response message)
func Handler(request events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	if request.Resource == "/ping" && request.HTTPMethod == "GET" {
		return controller.PingController(request)
	}

	return events.APIGatewayProxyResponse{Body: "{ \"message\" : \"No controller for requested resource and method found\" }", StatusCode: 400}, nil
}

func main() {
	lambda.Start(Handler)
}
