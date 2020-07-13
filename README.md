# OpenGraph API

This API allow you to quickly retrieve [OpenGraph](https://ogp.me/) information from any website.

## Endpoint

The root path `/` is the only endpoint of that API. It expects a single query string parameter: `url`.

```bash
GET https://opengraph.lewagon.com/?url=<URL_HERE>
```

For performance reason, the response is **cached for a day**. If you want to have real-time cache invalidation, please use the [Facebook Debugger](https://developers.facebook.com/tools/debug/).

### Example

:point_right: https://opengraph.lewagon.com/?url=https://www.lewagon.com

```json
{
  "data": {
    "site_name": "Coding Bootcamp Le Wagon | Europe's Best Coding Bootcamp",
    "title": "Coding Bootcamp | Le Wagon",
    "type": "article",
    "url": "https://www.lewagon.com/",
    "image": "https://dwj199mwkel52.cloudfront.net/assets/core/social/home-card-82f54b75841da25d31c2e99d673e68152942dfd3d7275380508a63f0d951b484.jpg",
    "description": "Change your life, learn to code. Le Wagon is ranked as the world's best coding bootcamp and has enabled thousands of people to change their careers."
  },
  "url": "https://www.lewagon.com/"
}
```

### Response Status Codes

The API will respond with the following HTTP codes:

- `200`: All good, here's your data
- `422`: Missing `url` in the query string
- `500`: Could not fetch OpenGraph info, check `error` key in the JSON answer
