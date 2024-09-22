require("dotenv").config()

const { MAILGUN_TEST_API_KEY } = process.env;

import fetch from 'node-fetch';

exports.handler = async (event, context) => {
    const email = JSON.parse(event.body).payload.email
    console.log(`Received a submission: ${email}`)

    const listAddress = 'test@sandbox1e7a4321500241bc88fbd6fb1ad7d544.mailgun.org';
    const response = await fetch(`https://api.mailgun.net/v3/lists/${listAddress}/members`, {
            method: 'POST',
            headers: {
                Authorization: `Token ${MAILGUN_TEST_API_KEY}`,
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
