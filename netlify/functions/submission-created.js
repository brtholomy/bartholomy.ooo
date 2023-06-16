require("dotenv").config()

const { BUTTONDOWN_API_KEY } = process.env;

import fetch from 'node-fetch';

exports.handler = async (event, context) => {
    const email = JSON.parse(event.body).payload.email
    console.log(`Received a submission: ${email}`)

    const response = await fetch( 'https://api.buttondown.email/v1/subscribers', {
		  method: 'POST',
		  headers: {
			  Authorization: `Token ${BUTTONDOWN_API_KEY}`,
			  'Content-Type': 'application/json',
		  },
		  body: JSON.stringify({ email }),
	    }
    );

    let responseText = await response.text();
    console.log('Response:', responseText);

    return {
      statusCode: 200,
      body: JSON.stringify({})
    }
}
