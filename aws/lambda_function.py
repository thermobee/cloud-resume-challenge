import json,boto3

dynamodb = boto3.resource('dynamodb')
TableName = 'VisitorCount'
table = dynamodb.Table(TableName)

def lambda_handler(event, context):
    response = table.get_item(Key= {'id': 'count'})
    count = response["Item"]["visitor_count"]

    new_count = str(int(count) +1)
    respone = table.update_item(
        Key = {'id': 'count'},
        UpdateExpression = 'set visitor_count = :c',
        ExpressionAttributeValues = {':c': new_count},
        ReturnValues = 'UPDATED_NEW'
    )

    message = {
        'Count': new_count
    }

    return {
        'statusCode': 200,
        'header': {
            'Access-Control-Allow-Headers': 'Content-Type',
            'Access-Control-Allow-Origin': 'https://todlazarov.com',
            'Access-Control-Allow-Methods': 'OPTIONS,GET'
        },
        'body': json.dumps(message)
    }