package main

import (
	"context"
	"encoding/json"
	"fmt"
	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/mailgun/mailgun-go/v4"
	"os"
	"time"
)

func AddListMember(domain, apiKey, email string) error {
	mg := mailgun.NewMailgun(domain, apiKey)

	member := mailgun.Member{
		Address:    email,
		Subscribed: mailgun.Subscribed,
	}
	mailinglist := "test@" + domain

	ctx, cancel := context.WithTimeout(context.Background(), time.Second*30)
	defer cancel()

	return mg.CreateMember(ctx, true, mailinglist, member)
}

// easiest to just define exactly what I need:
// https://gobyexample.com/json
type Payload struct {
	Email string
}

type Body struct {
	Payload Payload
}

func handler(request events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	var data Body
	if err := json.Unmarshal([]byte(request.Body), &data); err != nil {
		panic(err)
	}
	email := data.Payload.Email
	fmt.Println(email)

	domain := os.Getenv("MAILGUN_TEST_DOMAIN")
	apiKey := os.Getenv("MAILGUN_TEST_API_KEY")
	if err := AddListMember(domain, apiKey, email); err != nil {
		panic(err)
	}

	// TODO: serve the /subscribe/confirm page:
	return events.APIGatewayProxyResponse{
		StatusCode: 200,
		Body:       email,
	}, nil
}

func main() {
	// Make the handler available for Remote Procedure Call by AWS Lambda
	lambda.Start(handler)
}
