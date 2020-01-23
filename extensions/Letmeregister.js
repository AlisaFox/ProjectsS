// ==UserScript==
// @name         Letmeregister >:/
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  try to take over the world!
// @author       You
// @match        https://horizon.mcgill.ca/pban1/bwckcoms.P_Regs
// @require  http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js
// @grant        none
// ==/UserScript==

//code stops when the amount of credits you are registered for changes, in my case it's 12
//set #crn_id1 to the crn that you want, in my case 748, used 1568 for testing purposes

setInterval(function () {
    if(document.querySelector("body > div.pagebodydiv > form > table.plaintable > tbody > tr:nth-child(1) > td:nth-child(2)").innerText=="15.000"){
        document.querySelector("#crn_id1").value="27944";
       document.querySelector("body > div.pagebodydiv > form > input[type=submit]:nth-child(31)").click();
    }else{
    GM_notification( {text: 'it worked!', title: 'notification'})}
}, 15000); //every 15 secs
