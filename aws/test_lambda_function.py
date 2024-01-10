import boto3
import unittest
import json

class TestSum(unittest.TestCase):
    def test_dynamodb_value(self):
        client = boto3.resource('dynamodb')
        table = client.Table('VisitorCount')
        
        response = table.get_item(Key= {'id': 'count'})
        count = response["Item"]["visitor_count"]
        self.assertTrue(int(count) > 1)
        
if __name__ == '__main__':
    unittest.main()