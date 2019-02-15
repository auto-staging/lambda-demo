package controller

import "github.com/aws/aws-lambda-go/events"

func PingController(request events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	return events.APIGatewayProxyResponse{Body: "{ \"message\" : \"pong from Auto Staging\" }", StatusCode: 200}, nil
}
