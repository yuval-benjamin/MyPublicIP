import unittest
from src.app import app
import requests

class TestRootRoute(unittest.TestCase):
    
    # Create a test client
    def setUp(self):
        self.client = app.test_client()

    # Make a GET request to the root route and make sure our public IP is in the response
    def test_root(self):
        response = self.client.get('/')
        self.assertEqual(response.status_code, 200)
        
        # This uses a different method to get the public IP than the app itself
        ip = requests.get('https://api.ipify.org?format=json').json()['ip']
        self.assertIn(ip.encode(), response.data)
        
if __name__ == '__main__':
    unittest.main()