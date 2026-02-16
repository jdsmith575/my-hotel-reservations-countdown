# my-hotel-reservations-countdown
Display the My Hotel Reservations countdown on my Frame TV

## Dependencies

[ImageMagick](https://imagemagick.org/) is a free, open-source software suite that is required for stitching the image together and resizing it to fit the TV screen.

[xchwarze/samsung-tv-ws-api](https://github.com/xchwarze/samsung-tv-ws-api) is a Python library used to upload the image to the TV.

## Crontab

Add these two lines to your crontab file: 

```
0 0 * * * /home/my-user/disneyland-countdown/build_image.sh
*/5 * * * * /home/my-user/disneyland-countdown/upload_image.sh
```

The first line will build a new image every day at midnight. 

The second line attempts to upload the image to the TV every five minutes. This is necessary because if the TV is not on the upload will fail. If your TV is hardwired instead of on WiFi there is an option in the samsung-tv-ws-api library to wake up the TV. Using that you only need to upload the image once, but there doesn't appear to be any downside to uploading the image multiple times a day.
