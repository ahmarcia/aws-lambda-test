exports.handler = async (event) => {
  const response = {
    statusCode: 200,
    body: {
      event,
      content: 'Hello from Lambda!',
    },
  };
  
  return response
}
