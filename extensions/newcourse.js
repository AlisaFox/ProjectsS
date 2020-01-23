// ==UserScript==
// @name         New Userscript
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  try to take over the world!
// @author       You
// @match        https://vsb.mcgill.ca/vsb/criteria.jsp?access=0&lang=en&tip=1&page=results&scratch=0&term=202001&sort=none&filters=iiiiiiiii&bbs=&ds=&cams=Distance_Downtown_Macdonald_Off-Campus&locs=any&isrts=&course_0_0=PHYS-186&sa_0_0=&cs_0_0=--202001_17875--&cpn_0_0=&csn_0_0=&ca_0_0=&dropdown_0_0=al&ig_0_0=0&rq_0_0=&course_1_0=COMP-421&sa_1_0=&cs_1_0=--202001_738--&cpn_1_0=&csn_1_0=&ca_1_0=&dropdown_1_0=al&ig_1_0=0&rq_1_0=&course_2_0=PSYC-433&sa_2_0=&cs_2_0=--202001_17942--&cpn_2_0=&csn_2_0=&ca_2_0=&dropdown_2_0=al&ig_2_0=0&rq_2_0=&course_3_0=PHIL-415&sa_3_0=&cs_3_0=--202001_19650--&cpn_3_0=&csn_3_0=&ca_3_0=&dropdown_3_0=al&ig_3_0=0&rq_3_0=&course_4_0=COMP-551&sa_4_0=&cs_4_0=--202001_17135--&cpn_4_0=&csn_4_0=&ca_4_0=&dropdown_4_0=al&ig_4_0=0&rq_4_0=&course_5_0=COMP-308&sa_5_0=&cs_5_0=--202001_6652--&cpn_5_0=&csn_5_0=&ca_5_0=&dropdown_5_0=al&ig_5_0=0&rq_5_0=
// @grant        none
// ==/UserScript==

setInterval(function () {
    var std = 5;
    if(document.querySelector("#legend_box > div:nth-child(3) > div > div > div > label > div > div.selection_table > table > tbody > tr:nth-child(1) > td:nth-child(2) > span > span").innerText!=std){
       var newstd= document.querySelector("#legend_box > div:nth-child(3) > div > div > div > label > div > div.selection_table > table > tbody > tr:nth-child(1) > td:nth-child(2) > span > span").innerText;
        std = newstd;
        GM_notification ( {
          title: 'foo', text: '42', image: 'https://i.stack.imgur.com/geLPT.png',
          onclick: () => {
            console.log ("My notice was clicked.");
            window.focus ();
          }
      } );
        Notification ("Heeeeey");
    }
}, 15000); //every 15 secs
setTimeout(location.reload.bind(location), 60000);
