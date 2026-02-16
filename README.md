# my-hotel-reservations-countdown
The purpose of this project is to display the My Hotel Reservations countdown that you can see in the Disneyland or Disney World app on your phone on a Frame TV.

![Screenshot of the countdown image that is created.](/img/input/sample.png)

Each day, a new image is to created that shows the number of days remaining and the image is uploaded to the TV.

## Inputs

### Images from the app

You will need to build the image files needed to create the daily countdown. This can be done by taking screenshots of the mobile app and then splitting that image into several smaller images that will be stitched together later. It will take several days to get all of the digits, and you cannot get the Mickey head until you get to 99 days.

![Screenshot of how the image is pieced together.](/img/input/split.png)

These images should be stored in `img/input/<RESORT>`. See [img/input/grand_californian](/img/input/grand_californian/) for an example.

### Variables for the scripts

`build_image.sh` has several variables that you will need to set:

* `END_DATE` is the day your trip begins in YYYY-MM-DD format.
* `RESORT` is the name of the hotel you are staying at and the name of the folder the images are stored in.
* `BORDER_COLOR` is the hex value of the color used for the left and right border. Use https://htmlcolorcodes.com/color-picker/ to pick the perfect color.
* `SCREEN_HEIGHT` is the height of your TV screen in pixels. On my TV it is 2,870.
* `BORDER_WIDTH` is the width of the borders that get added to each side of the image. You'll need to determine the width of the TV screen and do some basic math to figure this out. On my TV it is 485.

`upload_image.sh` has two variables that you will need to set:

* `TV_IP` is the IP address of your TV. If your TV isn't on a static IP you may want to set that up.
* `OUTPUT_DIR` is the location of the image produced by build_image.sh
* `PROJECT_ROOT` is the location of the xchwarze/samsung-tv-ws-api Python library.

## Dependencies

[ImageMagick](https://imagemagick.org/) is a free, open-source software suite that is required for stitching the image together and resizing it to fit the TV screen.

[xchwarze/samsung-tv-ws-api](https://github.com/NickWaterton/samsung-tv-ws-api) is a Python library used to upload the image to the TV.

## Crontab

Add these two lines to your crontab file: 

```
0 0 * * * /home/my-user/disneyland-countdown/build_image.sh
*/5 * * * * /home/my-user/disneyland-countdown/upload_image.sh
```

The first line will build a new image every day at midnight. 

The second line attempts to upload the image to the TV every five minutes. This is necessary because if the TV is not on the upload will fail. If your TV is hardwired instead of on WiFi there is an option in the samsung-tv-ws-api library to wake up the TV. Using that you only need to upload the image once, but there doesn't appear to be any downside to uploading the image multiple times a day.

# Limitations

* This will not work for dates more than 999 days out.
* You cannot get the Mickey head until you're 99 days out.
* The TV must be turned on for the image to be uploaded.
