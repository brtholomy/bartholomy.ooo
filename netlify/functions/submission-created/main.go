package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"io/ioutil"
	"net/http"
	"os"
)

// easiest to just define exactly what I need:
// https://gobyexample.com/json
type IncomingPayload struct {
	// subscribe-form.html generates this, can't seem to rename. But keeping the
	// two JSON structs separate is probably better.
	Email string
}

type OutgoingPayload struct {
	// annoying but Buttondown expects this field
	Email string `json:"email_address"`
}

type Body struct {
	Payload IncomingPayload
}

func AddListMember(email string) error {
	key := os.Getenv("BUTTONDOWN_API_KEY")
	endpoint := "https://api.buttondown.email/v1/subscribers"

	payload := OutgoingPayload{email}
	b, err := json.Marshal(payload)
	if err != nil {
		return err
	}
	r := bytes.NewReader(b)

	req, err := http.NewRequest("POST", endpoint, r)
	if err != nil {
		return err
	}
	req.Header.Add("Authorization", "Token "+key)
	req.Header.Add("Content-Type", "application/json")

	res, err := http.DefaultClient.Do(req)
	if err != nil {
		return err
	}
	defer res.Body.Close()
	body, err := ioutil.ReadAll(res.Body)
	if err != nil {
		return err
	}
	fmt.Println(string(body))
	return nil
}

func handler(request events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	var data Body
	if err := json.Unmarshal([]byte(request.Body), &data); err != nil {
		return events.APIGatewayProxyResponse{
			StatusCode: 401,
			Body:       "Don't crawl here.",
		}, nil
	}
	email := data.Payload.Email
	fmt.Println(email)

	if err := AddListMember(email); err != nil {
		return events.APIGatewayProxyResponse{
			StatusCode: 500,
			Body:       "Something went wrong with subscription. Please try again.",
		}, err
	}

	return events.APIGatewayProxyResponse{
		StatusCode: 200,
		Body:       email,
	}, nil
}

func main() {
	// Make the handler available for Remote Procedure Call by AWS Lambda
	lambda.Start(handler)
}
