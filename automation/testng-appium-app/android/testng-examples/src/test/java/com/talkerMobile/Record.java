/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.talkerMobile;

import org.openqa.selenium.By;
import org.openqa.selenium.interactions.Actions;
import org.testng.Assert;
import org.testng.annotations.AfterMethod;
import org.testng.annotations.BeforeMethod;
import org.testng.annotations.Test;

import java.net.MalformedURLException;

/**
 *
 * @author payal
 */
public class Record extends SetupAppiumtest{

	@BeforeMethod
	public void beforeMethod() throws MalformedURLException {
		driver = setupDriver();
	}

        @Test(enabled = true, groups = { "Recording", "critical" })

	public void recordAndPlayConversation() throws InterruptedException, MalformedURLException {
			Thread.sleep(5000);
			driver.findElement(By.xpath("//*[@content-desc='OK' and contains(@index,'3')]")).click();
// Click on sort icon on the top
//driver.findElement(By.xpath("(//*[contains(@index,'1')])[2]")).click();
			Thread.sleep(5000);
			driver.findElement(By.xpath("//*[@content-desc='Record' and contains(@index,'4')]")).click();
			Thread.sleep(5000);
			if (driver.findElements(By.xpath("//*[contains(@text,'WHILE USING THE APP') and contains(@index,'0')]")).size()>0){
				Assert.assertTrue(true,"Confirmation message displayed.");
				driver.findElement(By.xpath("//*[contains(@text,'WHILE USING THE APP') and contains(@index,'0')]")).click();
			}
			Thread.sleep(3000);
			driver.findElement(By.xpath("//*[@content-desc='Pause' and contains(@index,'2')]")).click();
			if (driver.findElements(By.xpath("//*[@content-desc='Resume' and contains(@index,'2')]")).size()>0){
				Assert.assertTrue(true,"Recording has been Paused.");
				driver.findElement(By.xpath("//*[@content-desc='Resume' and contains(@index,'2')]")).click();
			}else{
				Assert.assertFalse(false,"Recording has not been paused.");
			}
			Thread.sleep(3000);
			driver.findElement(By.xpath("//*[@content-desc='Stop' and contains(@index,'3')]")).click();
			Thread.sleep(5000);
			if (driver.findElements(By.xpath("//*[@content-desc='Full Conversation' and contains(@index,'0')]")).size()>0){
				Assert.assertTrue(true,"Full Conversation tile displayed successfully.");
			}else{
				Assert.assertFalse(false,"Full Conversation tile is not displayed successfully.");
			}
			Thread.sleep(1000);
			if (driver.findElements(By.xpath("//*[@content-desc='Summary' and contains(@index,'0')]")).size()>0){
				Assert.assertTrue(true,"Summary tile displayed successfully.");
				driver.findElement(By.xpath("//*[@content-desc='Summary' and contains(@index,'0')]")).click();
			}else{
				Assert.assertFalse(false,"Summary tile is not displayed successfully.");
			}
			Thread.sleep(1000);
			if (driver.findElements(By.xpath("//*[@content-desc='Reminders' and contains(@index,'0')]")).size()>0){
				Assert.assertTrue(true,"Reminders tile displayed successfully.");
				driver.findElement(By.xpath("//*[@content-desc='Reminders' and contains(@index,'0')]")).click();
			}else{
				Assert.assertFalse(false,"Reminders tile is not displayed successfully.");
			}

			if (driver.findElements(By.xpath("//*[@content-desc='Food Order' and contains(@index,'0')]")).size()>0){
				Assert.assertTrue(true,"Food Order tile displayed successfully.");
				driver.findElement(By.xpath("//*[@content-desc='Food Order' and contains(@index,'0')]")).click();
			}else{
				Assert.assertFalse(false,"Food Order tile is not displayed successfully.");
			}
			if (driver.findElements(By.xpath("//*[contains(@class,'android.widget.Button') and contains(@index,'5')]")).size()>0){
				Assert.assertTrue(true,"Play order button displayed and clicked.");
				driver.findElement(By.xpath("//*[contains(@class,'android.widget.Button') and contains(@index,'5')]")).click();
			}else{
				Assert.assertFalse(false,"Not able to view play button.");
			}

			driver.findElement(By.xpath("//*[contains(@class,'android.widget.Button') and contains(@index,'0')]")).click();
			Thread.sleep(3000);
			for(int i=1; i<2; i++) {
				driver.findElement(By.xpath("//*[contains(@content-desc,'NewConversation')]")).click();
			}
			Thread.sleep(8000);
			if (driver.findElements(By.xpath("//*[@content-desc='Full Conversation' and contains(@index,'0')]")).size()>0){
				Assert.assertTrue(true,"Full Conversation tile displayed successfully.");
			}else{
				Assert.assertFalse(false,"Full Conversation tile is not displayed successfully.");
			}
			Thread.sleep(1000);
			if (driver.findElements(By.xpath("//*[@content-desc='Summary' and contains(@index,'0')]")).size()>0){
				Assert.assertTrue(true,"Summary tile displayed successfully.");
				driver.findElement(By.xpath("//*[@content-desc='Summary' and contains(@index,'0')]")).click();
			}else{
				Assert.assertFalse(false,"Summary tile is not displayed successfully.");
			}
			Thread.sleep(1000);
			if (driver.findElements(By.xpath("//*[@content-desc='Reminders' and contains(@index,'0')]")).size()>0){
				Assert.assertTrue(true,"Reminders tile displayed successfully.");
				driver.findElement(By.xpath("//*[@content-desc='Reminders' and contains(@index,'0')]")).click();
			}else{
				Assert.assertFalse(false,"Reminders tile is not displayed successfully.");
			}

			if (driver.findElements(By.xpath("//*[@content-desc='Food Order' and contains(@index,'0')]")).size()>0){
				Assert.assertTrue(true,"Food Order tile displayed successfully.");
				driver.findElement(By.xpath("//*[@content-desc='Food Order' and contains(@index,'0')]")).click();
			}else{
				Assert.assertFalse(false,"Food Order tile is not displayed successfully.");
			}
			if (driver.findElements(By.xpath("//*[contains(@class,'android.widget.Button') and contains(@index,'5')]")).size()>0){
				Assert.assertTrue(true,"Play order button displayed and clicked.");
				driver.findElement(By.xpath("//*[contains(@class,'android.widget.Button') and contains(@index,'5')]")).click();
			}else{
				Assert.assertFalse(false,"Not able to view play button.");
			}
			driver.findElement(By.xpath("//*[contains(@class,'android.widget.Button') and contains(@index,'2')]")).click();
			// Click on OK button on Delete message
			Thread.sleep(3000);
			driver.findElement(By.xpath("//*[@content-desc='OK' and contains(@index,'3')]")).click();
			Thread.sleep(3000);
			driver.findElement(By.xpath("//*[contains(@class,'android.widget.Button') and contains(@index,'1')]")).click();
			if (driver.findElements(By.xpath("//*[@content-desc='Using our browser extension' and contains(@index,'1')]")).size()>0){
				Assert.assertTrue(true,"Information message displayed Successfully.");
			}else{
				Assert.assertFalse(false,"Information message not displayed Successfully");
			}
			// Verify Browser Extension displayed successfully
			Thread.sleep(3000);
			if (driver.findElements(By.xpath("//*[contains(@class,'android.view.View') and contains(@index,'1')]")).size()>0){
				Assert.assertTrue(true,"Browser Extension displayed Successfully.");
			}else{
				Assert.assertFalse(false,"Browser Extension not displayed Successfully");
			}
			// Click on EULA to view term and condition
			driver.findElement(By.xpath("//*[@content-desc='EULA' and contains(@index,'4')]")).click();
			// Click on Agree
			Thread.sleep(3000);
			driver.findElement(By.xpath("//*[@content-desc='Agree' and contains(@index,'3')]")).click();
			//Click on Guided tour
			driver.findElement(By.xpath("//*[@content-desc='Guided Tour' and contains(@index,'5')]")).click();
			// Verify Guided tour screen
			if (driver.findElements(By.xpath("//*[contains(@class,'android.widget.ImageView') and contains(@index,'0')]")).size()>0){
				Assert.assertTrue(true,"Guided tour screen displayed Successfully.");
			}else{
				Assert.assertFalse(false,"Guided tour screen not displayed Successfully");
			}

	}
}

