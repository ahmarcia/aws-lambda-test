const moment = require('moment')

exports.handler = async (event) => {
  const response = {
    statusCode: 200,
    body: {
      updated: true,
      now: moment(),
      event,
      content: 'Hello from Lambda!',
    },
  };
  
  return response
}
