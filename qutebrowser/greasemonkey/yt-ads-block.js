// ==UserScript==
// @name        YouTubeAnnoyancesRemover
// @namespace   com.vsubhash.js.youtube-annoyances-remover
// @description Disables ads, turns off autoload/autoplay, adds RSS link, deletes "recommended for you" videos, unhides description, displays all comments, changes profile link to videos page; changes region to US, displays video thumbnail image, and adds a link to the lighter version on Hooktube if video is not playable for codec reasons. Supports Firefox-based browser up to version 36. Newer versions should use a UserAgent (UA) spoofer add-on. YouTube loads a lighter version of the YouTube page for older browsers. This script will require the GreaseMonkey add-on to be executed by the Firefox browser. For embedded YouTube videos, use the script com.vsubhash.js.embedded-video-catcher.user.js.
// @include     https://www.youtube.com/watch*
// @include     https://www.youtube.com/channel*
// @include     https://www.youtube.com/user*
// @version     2020.01
// @grant       none
// ==/UserScript==

var sAdStyle = " { visibility: none!important; display: none!important; }";
var oDlDiv;

document.addEventListener("readystatechange", fixYouTubeAnnoyances, false);
try {
	console.log("YAD: Page start");
	window.setTimeout(pauseVideos, 2*1000);
	window.setTimeout(pauseVideos, 4*1000);    
	window.setTimeout(pauseVideos, 6*1000);    
} catch (e) { }



function fixYouTubeAnnoyances() {
	if ((document.readyState == "interactive") || (document.readyState == "complete")) {
		console.log("YAD: loaded");
		try {
			pauseVideos();
		  window.setTimeout(showDescription, 1*200);    
		  window.setTimeout(closeVideoAds, 2*200);
		  window.setTimeout(changeRegion, 3*200);

		  window.setTimeout(addRssButton, 1*1000);
		  window.setTimeout(changeProfileLink, 2*1000); 
		  window.setTimeout(pauseVideos, 3*1000);    
		  window.setTimeout(removeRecommendedForYouAds, 4*1000);  
		  window.setTimeout(disableAndHideAdContainers, 5*1000);
		  window.setTimeout(disableAutoPlay, 6*1000);
		  window.setTimeout(addVideoDownloadList, 7*1000);

		  window.setTimeout(loadAllComments, 15*1000);
		  window.setTimeout(removeRecommendedForYouAds, 16*1000);  		  

		} catch (e) {
		  console.error("YAD Error: " + e);
		}
	}
}


function addRssButton() { 
  console.log("YAD: addRssButton")
	var oLink, oLinkEl, oChannelTag, oRssImg, oRssLink, sChannel, sChannelName, sUserName, sFeedUrl;
	
	// Android 1.6
	oLink = document.querySelector("div.tv span.gmb a");
	oChannelTag = document.querySelector("div.tv span.gmb a span");
	if (oLink == null) {
		// Android 3+
		oLink = document.querySelector("a.slim-owner-icon-and-title");
		oChannelTag = document.querySelector("a.slim-owner-icon-and-title div h3");
	}
	if (oLink == null) {
		// Android 46
		oLink = document.querySelector("div.yt-user-info a");
		oChannelTag = document.querySelector("div.yt-user-info a");
	}
	if (oLink == null) {
		// Android 60
		oLink = document.querySelector("div#owner-container *#owner-name a");
		oChannelTag = document.querySelector("div#owner-container *#owner-name a");
	}
	
	if ((oLink ==null) || (oChannelTag == null)) { return; } else {
		console.log("YAD: Channel name found.");
		sChannelName = oChannelTag.textContent;
		sChannelName = sChannelName.replace(/^\s+|\s+$/g, '');
		console.log("YAD: Channel link found.");
	  if (oLink.getAttribute("href").indexOf("/channel/") == 0) {
			sChannel = oLink.getAttribute("href").substr("/channel/".length);
			sFeedUrl = "https://www.youtube.com/feeds/videos.xml?channel_id=&quot; + sChannel;
			console.log("YAD: RSS ~ " + sChannelName + " = " + sFeedUrl);
		} else if (oLink.getAttribute("href").indexOf("/user/") == 0) {
		  sUserName = oLink.getAttribute("href").substr("/user/".length);
		  sFeedUrl = "https://www.youtube.com/feeds/videos.xml?user=&quot; + sUserName;
			console.log("YAD: RSS ~ " + sChannelName + " = " + sFeedUrl);
		} else { return; }
		oLinkEl = document.createElement("link");
    oLinkEl.setAttribute("rel", "alternate");			
    oLinkEl.setAttribute("title", sChannelName);
    oLinkEl.setAttribute("type", "application/rss+xml");
    oLinkEl.setAttribute("href", sFeedUrl);
    document.getElementsByTagName("head")[0].appendChild(oLinkEl);
    
    oRssImg = document.createElement("img");
    oRssImg.setAttribute("style", "margin: auto 1em; ");
    oRssImg.setAttribute("alt", "RSS");
    oRssImg.setAttribute("src", "https://www.google.com/images/rss.png&quot;);
    
    oRssLink = document.createElement("a");
    oRssLink.setAttribute("id", "mvytRssFeedLink");
    oRssLink.setAttribute("href", sFeedUrl);
    oRssLink.setAttribute("title", "RSS feed link for this channel");
    oRssLink.setAttribute("style", "text-decoration: none; border-style: none; ");
    oRssLink.appendChild(oRssImg);
    
    if (document.getElementById("mvytRssFeedLink") == null) {
    	oChannelTag.insertAdjacentHTML('afterend', oRssLink.outerHTML);
    }
  }
}


function pauseVideos() {
  console.log("YAD: Pausing videos");
  try {
    var oVideoEls = document.getElementsByTagName("video");
    for (var i = 0; i < oVideoEls.length; i++) {
    	oVideoEls[i].pause();    
    	oVideoEls[i].muted = true;
    	if (oVideoEls[i].src.indexOf("pltype=adhost") > -1) {
    		console.log("YAD: Video ad found… closing tab");
				window.open(location.href, '_blank');
				window.close();
    	}
    	console.log("YAD: Pausing video " + (i+1));
    	if (!oVideoEls[i].paused) {
    		oVideoEls[i].pause();	
    	}      
      //oVideoEls[i].volume = 0.6;  // custom controls do not update
      oVideoEls[i].muted = true;
      oVideoEls[i].removeAttribute("autoplay");
      oVideoEls[i].removeAttribute("loop");
      oVideoEls[i].removeAttribute("controls");      
      oVideoEls[i].setAttribute("preload", "none");
      oVideoEls[i].pause();
    }
    var oButtons = document.getElementsByTagName("button");
    for (var i = 0; i < oButtons.length; i++) {
    	if (oButtons[i].className) {
    		if (oButtons[i].className.indexOf("ytp-mute-button") > -1) {
    			console.log("YAD: Mute button " + oButtons[i].className);
		  		oButtons[i].click();
		  		oButtons[i].click();		  		
		  	}
    	}
    }
  } catch (e) {
	  console.error("YAD: Error – " + e);
  }
}


function showDescription() {
  console.log("YAD: Finding description…");
  if (document.getElementById("action-panel-details") != null) {
    document.getElementById("action-panel-details").className = "action-panel-content yt-uix-expander yt-card yt-card-has-padding";
  }
  console.log("YAD: Description unhidden.");
}


function closeVideoAds() {
  console.log("YAD: Detecting video ads…");        
  if ((document.getElementsByClassName("videoAdUiTopButtons").length > 0) || (document.getElementsByClassName("videoAdUi").length > 0)) {
    console.log("YAD: Video ad found");      
    window.open(location.href, '_blank');
    window.close();
 	} else {  
    console.log("YAD: No video ad");
  }
}


function disableAutoPlay() {
  var oEl = document.getElementById("autoplay-checkbox"); 
  if (oEl == null) {
  	console.log("YAD: Did not find autoplay button.");
  } else if (oEl.hasAttribute("checked")) {
  	console.log("YAD: Disabling autoplay…");  	
  	oEl.click();
  } else {
  	console.log("YAD: Autoplay already disabled.");  	  
  }
}


function removeRecommendedForYouAds() {
  console.log("YAD: Removing recommended videos");
  var oRelatedColumn = document.getElementById("watch-related");
  if (oRelatedColumn != null) {
    var arRelatedVids = oRelatedColumn.getElementsByTagName("li");
    var j = 0;
    if (arRelatedVids.length > 0) {
      for (var i = arRelatedVids.length-1; i > -1; i–) {        
        if (arRelatedVids[i].textContent.indexOf("Recommended for you") != -1) {
          //console.log("YAD: Removing " + arRelatedVids[i].textContent);
          arRelatedVids[i].parentNode.removeChild(arRelatedVids[i]);
          ++j;
        }
      }
    }
    console.log("YAD: Removed " + j  + " recommended videos");      
  }
  
  oRelatedColumn = document.getElementById("watch7-sidebar-modules");
  if (oRelatedColumn != null) {
    var arRelatedVids = oRelatedColumn.getElementsByClassName("watch-sidebar-section");
    var j = 0;
    if (arRelatedVids.length > 0) {
      for (var i = arRelatedVids.length-1; i > -1; i–) {        
        if (arRelatedVids[i].textContent.indexOf("Recommended for you") != -1) {
          //console.log("YAD: Removing " + arRelatedVids[i].textContent);
          arRelatedVids[i].parentNode.removeChild(arRelatedVids[i]);
          ++j;
        }
      }
    }
    console.log("YADN: Removed " + j  + " new recommended videos");      
  }  
}


function disableAndHideAdContainers() {
  console.log("YAD: Disabling/deleting ad containers…");
  var arDivIds = ["AdSense", "watch7-sidebar-ads", "promotion-shelf", "live-chat-iframe", "invideo-overlay:7", ];
  var arDivClasses = [ "adDisplay", "annotation", "html5-endscreen", "iv-promo", "video-ads", "videoAdUiBottomBar", "ytp-ad-module", "ytp-endscreen-content", "ytp-cards-button", "ytp-cards-teaser", "ytp-ad-overlay-container", "ytp-ad-overlay-slot", "ytp-ad-text-overlay", "ytp-ad-overlay-ad-info-button-container", "ytp-ad-hover-text-button", "ytp-ad-info-hover-text-button", "ytp-ad-overlay-text-image", "ytp-ad-overlay-text-image", "ytp-ad-image-overlay", "ytp-ad-overlay-close-container", "ytp-ad-overlay-close-button" ];

  for (var i = 0; i < arDivIds.length; i++) {
    var oDiv = document.getElementById(arDivIds[i]);
    if (oDiv != null) {
      oDiv.style.visibility = "hidden!important";
      oDiv.style.display = "none!important";          
      oDiv.parentNode.removeChild(oDiv);
      console.log("YAD: Removed " + arDivIds[i] + " by ID");
    } else {
      console.log("YAD: Not found: " + arDivIds[i] + " by ID");
    }      
    sAdStyle = "#" + arDivIds[i] +  ((i==0)?" ":" , ") + sAdStyle;      
  }
  for (var i = 0; i < arDivClasses.length; i++) {
    var oDivs = document.getElementsByClassName(arDivClasses[i]);
    if (oDivs != null) {
      for (var j = 0; j < oDivs.length; j++) {
        oDivs[j].style.visibility = "hidden!important";
        oDivs[j].style.display = "none!important";          
        oDivs[j].parentNode.removeChild(oDivs[j]);
      }
    } else {
      console.log("YAD: Not found: " + oDivs[j] + " by ID");
    }
    sAdStyle = "*." + arDivClasses[i] +  " , " + sAdStyle;      
  }
  document.getElementsByTagName("head")[0].innerHTML = document.getElementsByTagName("head")[0].innerHTML + "\n<style>" + sAdStyle + "\n</style>";
}


function changeRegion() {
	var oLangButton = document.getElementById("yt-picker-country-button");
	if (oLangButton != null) {
		if (oLangButton.textContent.indexOf("United States") == -1) {
			oLangButton.click();
			window.setTimeout(
				function() {
					var arRegions = document.getElementsByClassName("yt-picker-item");
					for (var i = 0; i < arRegions.length; i++) {
						if (arRegions[i].textContent.indexOf("United States") > -1) {
							arRegions[i].click();
							break;
						}
					}
				}, 3*1000); 
		}
	}
	
}

 
function changeProfileLink() { 
  console.log("YAD: Changing profile link")
  var oDivs = document.getElementsByTagName("div");
  if ((oDivs != null) && (oDivs.length > 0)) {
    for (var i = 0; i < oDivs.length; i++) { if (oDivs[i].className == "yt-user-info") { 
      var oAnchors = oDivs[i].getElementsByTagName("a"); 
      if ((oAnchors != null) && (oDivs.length>1)) {
          var bFound = false;
          for (var j = 0; j < oAnchors.length; j++) {
            if (oAnchors[j].href.substring(0, "https://www.youtube.com/channel/&quot;.length) == "https://www.youtube.com/channel/&quot;) {
              oAnchors[j].href = oAnchors[j].href + "/videos";
              oLatestVideosLink = document.createElement("a");
              oLatestVideosLink.setAttribute("style", "background-image: url(https://s.ytimg.com/yts/imgbin/www-hitchhiker-vflYQU35a.png); width: 17px; height: 17px; background-position: -94px -472px; border-style: none; margin: 0; padding: 0; ");
              oLatestVideosLink.setAttribute("id", "MvPopularLink");
              oLatestVideosLink.setAttribute("href", oAnchors[j].href + "?view=0&sort=p&flow=grid");
              oAnchors[j].insertAdjacentHTML("afterend", oLatestVideosLink.outerHTML);
             
              bFound = true;
              break;
            }
          }
          if (bFound) { break; }
        }
      }
    }
  }
}


var iLoadAllCommentsTimeout = 0;
function loadAllComments() {
  if (iLoadAllCommentsTimeout > 0) {
  	window.clearTimeout(iLoadAllCommentsTimeout);
  }
  var oDiv = document.getElementById("watch-discussion");
  if (oDiv == null) { return; }
  var oButtons = oDiv.getElementsByClassName("comment-section-renderer-paginator");
  if (oButtons != null) {
  	console.log("YAD: Comments");
		if (oButtons[0] != null) {
			oButtons[0].click();
			iLoadAllCommentsTimeout = window.setTimeout(loadAllComments, 20*1000);
		}
  }

}

function parseYTPlayer() {

  console.log("YAD: Inside parser" );
  console.log("YAD: Title" + ytplayer.config.args.title);
  
  try { 
    if (document.getElementsByTagName("video")[0] && (document.getElementsByTagName("video")[0].pause)) {
      document.getElementsByTagName("video")[0].pause();
    }
  } catch (e) {
    window.alert(e);
  }
  
  var arFormatParams, arFormats, i, j, sURL, sQuality, sMimeType, sExtension;
  var oDlList, oDlListItem;
  
  oDlList = document.getElementById("mvyJsList");
  if (oDlList == null) { 
    return;
  }
  
  oDlList.innerHTML += "<li><a href=\"" + location.href.replace("www.you", "www.hook") + "\" style=\"color: navy; font-weight: bold; \" target=\"_blank\">Load in HookTube</a></li>";
  
  var oFormats = JSON.parse(ytplayer.config.args.player_response);

  var arFormats = oFormats.streamingData.formats;
  for (i = 0; i < arFormats.length; i++) {
    oDlListItem = document.createElement("li");    

    var sFormat = arFormats[i].mimeType.split(';')[0];
    if (arFormats[i].mimeType.split(';')[0] == "video/mp4") {
      sFormat = "M";
    } else if (arFormats[i].mimeType.split(';')[0] == "video/webm") {
      sFormat = "W";
    }
    console.log("YAD: Format " + arFormats[i].quality + " – " + arFormats[i].qualityLabel + " – " + arFormats[i].mimeType.split(';')[0]);

    oDlListItem.innerHTML = "<a title=\"" + arFormats[i].mimeType.replace(/\"/g,"") +  "\" style=\"color: navy; font-weight: bold; \" target=\"_blank\" href=\"" + arFormats[i].url + "\">" + document.title.replace(" – YouTube", "") + " – " + arFormats[i].qualityLabel + " " + sFormat + "</a>";
    oDlList.appendChild(oDlListItem);
        

  }
    
} 


function addCurrentPlayURL() {
  var oList = document.getElementById("mvyJsList");
  if (oList != null) {
		if (document.getElementById("movie_player") != null) {
			if (document.getElementById("movie_player").getElementsByTagName("video") != null) {
				var oVideo = document.getElementById("movie_player").getElementsByTagName("video")[0];
				if (oVideo.src) {
					oList.innerHTML += "<li><a id=\"VidLinkUrl\" title=\"" + document.title + "\" download=\"" + document.title.replace(/\s+/ig, "-").replace(/-{2,}/ig, "-") + ".mp4\" style=\"color: navy; font-weight: bold; \" target=\"_blank\" href=\"" + oVideo.src + "\">" + document.title + "</a></li>";
					console.log("YAD: Video URL = " + oVideo.src);
					
					oVideo.addEventListener(
						"loadeddata", 
						function() {
						  console.log("YAD: New video loaded");
							document.getElementById("VidLinkUrl").setAttribute("href", document.getElementsByTagName("video")[0].src);
						}, false);
					
				} else {
					console.log("YAD: Error in player");	
				}
			}
		} else {
			console.log("YouTube detector: No player");	
			oList.innerHTML += "<li><a style=\"color: navy; font-weight: bold; \"href=\"" + location.href.replace("www.you", "www.hook") + "\" style=\"color: navy; font-weight: bold; \" target=\"_blank\">Load in HookTube</a></li>";
		}		
	}
}


function addVideoDownloadList() {
  console.log("Executing YouTube detector");
  var i, n, oDlButtonEl, oVideosList;

  oDlDiv = document.createElement("div");
  
  oDlDiv.setAttribute("id", "mvyJsDiv");
  oDlDiv.setAttribute("style", "background-color: orange!important; border: 2px dashed firebrick; font-size: 0.34cm!important; font-family: sans-serif!important; line-height: 0.4cm!important; margin: 1em auto; padding: 1em; min-height: 120px; ");
  oDlDiv.innerHTML = "Download video from:";

  var oTwitterImage = document.querySelector("html head meta[name='twitter:image']");
  console.log("YAD: Twitter image" + oTwitterImage.getAttribute("content"));
  if (oTwitterImage) {
    oDlDiv.innerHTML += "<img src=\"" + oTwitterImage.getAttribute("content") + "\" style=\"max-width: 200px; float: right; margin: 1em auto 1em 1em; \" />\n";
  } else if (window.URL) {
  	var oURL = new URL(location.href);
  	var sID = oURL.searchParams.get("v");
  	oDlDiv.innerHTML += "<img src=\"https://i.ytimg.com/vi/&quot; + sID + "/hqdefault.jpg\" style=\"max-width: 200px; float: right; margin: 1em auto 1em 1em; \" />";
  }

  oDlList = document.createElement("ul");
  oDlList.setAttribute("style", "display: block; list-style: disc inside none; margin-left: 1em!important; ");
  oDlList.setAttribute("id", "mvyJsList");
  oDlDiv.appendChild(oDlList);
  
  if (location.href.indexOf("youtube.com/watch") > -1) {
    document.getElementById("watch-headline-title").appendChild(oDlDiv);
    addCurrentPlayURL();
    parseYTPlayer();
  } else if (location.href.indexOf("youtube.com/embed/") > -1) {
		// Use the script com.vsubhash.js.embedded-video-catcher
  }
}
