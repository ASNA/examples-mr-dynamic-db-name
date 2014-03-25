
Dynamically override MR's database connection
---

These instructions, and its accompanying example, show how to dynamically override MR's database connection at runtime. This technique uses a value provided in the query string to determine what database name should be used. 

### Step 1. Configure the app to use a database name 

By default, MR apps prompt the user for logon credentials. To force the app to bypass that signon screen and use a previously configured database name, find the `web.config` file in the root folder of your project. Open it with Visual Studio. 

At the end of that file are several `appSettings.` You want to specify only: 

  * MobileRPGLibraryName
  * MobileRPGPogramName
  * MobileRPGDatabaseName 

You'll probably need to add `MobileRPGDataBaseName.` Comments in XML start with `<!--` and end with `-->`. You can comment out the unused `appSettings` keys or delete them.

When you're done, the end of the `web.config` should look like this where the default database name along with the library and program name (the order of these values isn't significant). This document provides further instructions on how to override this default database name at runtime with a value provided from the query string.

    <!--
        <add key="MobileRPGUsername" value="nnnnn"/>
        <add key="MobileRPGServerName" value=""/>
        <add key="MobileRPGServerPort" value="5110"/>
        <add key="MobileRPGPromptForServer" value="yes"/>
    -->
    
        <add key="MobileRPGLibraryName" value="rppass"/>
        <add key="MobileRPGProgramName" value="HelloRPG"/>
        <add key="MobileRPGDatabaseName" value="*Public/MRX"/>
    
      </appSettings>
    </configuration>


###Step 2. Specify a test URL to launch the app in Visual Studio

At runtime, users will launch your app with a URL you provide for them--or, specifically in Roto Rooter's case, with a URL provided by the Java program the mobile app uses. To test your mobile app in Visual Studio, you need to manually provide a URL with the query string value set. 

Do this by using Visual Studio's top-level View->Property Pages menu. Select the Start Options entry from the dialog displayed.

![](https://dl.dropboxusercontent.com/u/19172063/ProjectProperties.png)

In the yellow box, put the URL of your app used by Visual Studio. You'll need to run the app and copy the URL from the browser's address bar to make sure you get the port correct. Append a query string key and value as shown below.   

    http://localhost:3333/PassServerName/Monarch/SignOn.aspx?DBNAME=MR

The key must be DBNAME and the value should be the root of the DBName. For example, if your DB name is `*Public/MR` then DBNAME's value should be `MR`. Don't forget the question mark! 

Press F5 to run the program once from Visual Studio to ensure this is working before continuing.


### Step 3. Add an ASPX page to display when the database name provide isn't valid

The code below is stubbed in to ensure that the database provided is valid. If the database name provide isn't valid, control will be passed to an `ASPX` page. Add a standard (not a Mobile RPG display file page) `ASPX` page in the root of your project and name it `DBNameError.aspx.` Add whatever text or images you want to this page to help inform the user about what has happened. 
 
### Step 4. Determine the database name from the value provided on the query string

In the root folder of your project you'll find a file named `Global.asax`. Three changes need to be made to this file. An overview of the changes needed are shown below (as an image--to easily provide the context of where the changes should go). Directly below the image is the three chunks of code you need presented as text for easy copy and pasting.  

![](https://dl.dropboxusercontent.com/u/19172063/globalasax.code.png)

The image shows line numbers that may not be exactly the line numbers you see in your `Global.asax.` Don't worry about it if the line numbers in your `Global.asax` aren't exactly as shown. Changes 1 and 2 are in the `Session_Start()` subroutine. If your line numbers are different, find that subroutine and work your way down from its beginning. You'll quickly see where these changes go.   

Change 1:

    DclFld DBName Type(*String) 
    
    If ( Request["DBNAME"] <> *Nothing ) 
        DBName = "*Public/" + Request["DBNAME"].ToString()
    Else 
        // Default basebase name.
        DBName = "*Public/MR" 
    EndIf 
    
    If NOT InWhiteList(DBName) 
        Server.Transfer("~/DBNameError.aspx") 
        LeaveSr 
    EndIf

Change 2: 

    Job.LDC["DB"] = DBName

Change 3:
 
    BegFunc InWhiteList Type(*Boolean)
        DclSrParm DBName Type(*String)
        
        LeaveSr *True 
    EndFunc             

**Change 1:** Fetches the `DBNAME` value from the query string and prepends `*Public/` to it to make a public database name out of the root database name passed on the query string. If a `DBNAME` key isn't provided on the query string, the `Else` clause provides a default database name.  

The database name is then passed to the `InWhiteList()` function (more on this function in a moment) to ensure the database name is valid. If it isn't, the app ends and the `DBNameError.aspx` page added in Step 3 is displayed. 
 
Change 2: The single line in Change 2 assigns the now-approved database name to the `DB` key of the LDC. LDC stands for Local Data Collection. The LDC provides a way to pass ad hoc data around in an MR (or Wings or Monarch) app. 

Change 3: These lines add an `InWhiteList()` function for approving the database name derived from the query string value provided. As provided here, this function unconditionally returns true thereby approving all database names. Add your own logic here to approve database name values in some fashion.

### Step 5. Change the active database name for the app. 

There is a file named `MobileRPGJob.vr` in the root folder of your project. Open it with Visual Studio and find the `Connect` subroutine (at about line 150 or 160). The end of that subroutine will look like this:
   
            ...
            ...
            ...
    		If *not hasDbName
    			myDatabase.Server = logonInfo.Server
    			myDatabase.Port = logonInfo.Port
    			myDatabase.User = logonInfo.User
    			myDatabase.Password = logonInfo.Password
    		EndIf
            try
                myDataBase.DBName = *This.LDC["DB"].ToString()
                CONNECT myDatabase
                leave
            catch dgEx dgException
                logonInfo.Message = dgEx.Message
    			hasDbName = *false
            endtry
        enddo
    
        PsdsJobUser = myDatabase.User
    	leavesr *true
    EndFunc

Immediately after the Try statement, add this line:

    myDataBase.DBName = *This.LDC["DB"].ToString()

The end of the `Connect` subroutine should now look like this:

            ...
            ...
            ...
    		If *not hasDbName
    			myDatabase.Server = logonInfo.Server
    			myDatabase.Port = logonInfo.Port
    			myDatabase.User = logonInfo.User
    			myDatabase.Password = logonInfo.Password
    		EndIf
            try
                myDataBase.DBName = *This.LDC["DB"].ToString()
                CONNECT myDatabase
                leave
            catch dgEx dgException
                logonInfo.Message = dgEx.Message
    			hasDbName = *false
            endtry
        enddo
    
        PsdsJobUser = myDatabase.User
    	leavesr *true
    EndFunc

Your MR app will connect with the DB name specified. 