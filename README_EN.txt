This addon was written by Forbium and Rogolist.
The Whisper Bind addon is written so that you can whisper to a specific player by pressing buttons without occupying
a separate slot for the macro.

<<<<<<< HEAD
Usage.
To configure whispering, you need to go to the addon settings by clicking on the “settings” button, it will open a
window where there will be three columns with fields. In the first column we write what we want the button to be called
(to make it easy to find), in the second, who we want to send the message to, and in the third, what kind of message we
want to send. After completing the settings, you need to click the “save” button and you can close the settings window.
Now the next time your account is launched, you will not need to enter this information into the settings, it will be
automatically loaded.

Well suited for the Whispercast addon if you do not need to send many different messages.
If the window goes beyond the screen, you need to write the command /run whisperbind:SetPoint("TOPLEFT",600,-200);.
This will bring the window to the center of the screen.
=======
Usage:
To configure the whisper, you need to open the addon settings window by clicking on the "options" button, after
clicking it, a window will open in which there will be 4 columns:
    1.ButtonID  - display of the button name
    2.Player    - the player to whom the message will be sent
    3.Message   - the text of the message
    4.Category  - the category to which the message belongs (for convenient filtering)
there are also 4 buttons above the columns:
    1.Save  - saves all values ​​from the fields in the settings window
    2.New   - adds another line with a button for a message
    3.Del   - shows/hides buttons for deleting lines
    4.Adv   - shows/hides buttons for advanced features, namely 5 buttons:

        1.Stats     - displays statistics about pressing current bindings (buttons) in the chat
        2.History   - displays the name of the pressed button and the time of pressing (only the last 10 presses)
        3.Export    - displays settings in the chat
        4.Import    - (information in the chat)
        5.Auto      - shows/hides the auto-reply setting.
Setting up an auto-reply is done using one input field (a word is entered that will be used as a sign for using
the answer) and a checkbox (enables and disables the auto-reply function (only messages that have a check mark
will be able to use the auto-reply))
On the main window above the "settings" button there is a "categories" button ("Cat:") when you click on the
button the filter switches to the next category. By default there are 6 categories (All, Trade, Guild, Raid,
PvP, Communication) only these categories have their own distinctive colors that will be displayed on the button.
If you enter a missing category in the category field in the settings, a filter for it will also be added. When
you right-click on the "categories" button, a list of all available categories will be written out in the chat.

You can also use some variables in messages: %player%, %myname%, %time%, %zone%, %guild%, %level%, %class%

Well suited for the Whispercast addon if you do not need to send many different messages.
>>>>>>> origin/main
