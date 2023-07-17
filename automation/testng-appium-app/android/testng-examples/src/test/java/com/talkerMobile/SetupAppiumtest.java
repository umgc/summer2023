/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.talkerMobile;

import io.appium.java_client.AppiumDriver;
import io.appium.java_client.android.AndroidDriver;
import org.openqa.selenium.remote.DesiredCapabilities;

import java.io.File;
import java.net.MalformedURLException;
import java.net.URL;

public class SetupAppiumtest {
    public AppiumDriver driver = null;
    public AppiumDriver setupDriver() throws MalformedURLException {
         
		 DesiredCapabilities caps = new DesiredCapabilities();
        String apkpath = "alphaSoft.apk";
        File app = new File(apkpath);
        caps.setCapability("udid", "emulator-5554");
        caps.setCapability("plateformName", "Android");
        caps.setCapability("appPackage", "com.example.talker_mobile_app");
        caps.setCapability("appActivity", "com.example.talker_mobile_app.MainActivity");
        try {

             driver = new AndroidDriver(new URL("http://0.0.0.0:4723/wd/hub"), caps);
           
        } catch (MalformedURLException e) {

            System.out.println(e.getMessage());

        }
        return driver;
    }
}
