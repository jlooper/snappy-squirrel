--calculate the aspect ratio of the device:
local aspectRatio = display.pixelHeight / display.pixelWidth

application = {
   content = {
      width = aspectRatio > 1.5 and 320 or math.ceil( 480 / aspectRatio ),
      height = aspectRatio < 1.5 and 480 or math.ceil( 320 * aspectRatio ),
      scale = "letterBox",
      fps = 30,

      imageSuffix = {
         ["@2x"] = 1.5
      },
   },

   notification =
    {
        iphone =
        {
            types =
            {
                "badge", "sound", "alert", "newsstand"
            }
        },
      google =
      {
         -- This Project Number (also known as a Sender ID) tells Corona to register this application
         -- for push notifications with the Google Cloud Messaging service on startup.
         -- This number can be obtained from the Google API Console at:  https://code.google.com/apis/console
         --projectNumber = "131713581397",
      },
    }
}


