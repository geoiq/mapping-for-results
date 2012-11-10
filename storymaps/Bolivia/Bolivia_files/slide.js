// JavaScript Document

//addLoadEvent(startSlides);
window.onload = startSlides;

// init vars
var slideCurrent = 1;
var slidesStatus = "play";
var timeoutId;


// function to start slideshow and timer
function startSlides() {
	// build arrows/squarea div
	buildArrows();
	// start slideshow timer
	timeoutId = setTimeout("slideNext()",5000);
}


// function to build arrows div
function buildArrows() {
	// get arrows div
	var arrowsDiv = document.getElementById("arrows_home");
	// build left arrow
	//var leftArrow = "<a href=\"#\" onclick=\"slidesPause(); slidePrevious(); return false\"><img src=\"images/arrow-left.gif\" alt=\"arrow left\" width=\"7\" height=\"10\" border=\"0\" /></a> ";
	// get # of slides
	var slidesCount = slidesGetCount();
	// build squares
	var arrowSquares = "";
	for (var i = 0; i < slidesCount; i++) {
		arrowSquares = arrowSquares + "<a href=\"#\" onclick=\"slidesPause(); showSlide('" + (i + 1) + "'); return false\"><img src=\"http://www.worldbank.org/wb/images/cache30/home/storybullet2.gif\" border=\"0\" id=\"sq" + (i + 1) + "\" name=\"sq_home\" /></a> "
	}
	// build right arrow
	//var rightArrow = "<a href=\"#\" onclick=\"slidesPause(); slideNext(); return false\"><img src=\"images/arrow-right.gif\" alt=\"arrow right\" width=\"7\" height=\"10\" border=\"0\" /></a>";
	// build arrows html
	//var arrowsHtml = leftArrow + arrowSquares + rightArrow;
	var arrowsHtml = arrowSquares;
	arrowsDiv.innerHTML = arrowsHtml;
	// change sq img
	changeSq(1);
}


// function to go to next slide
function slideNext() {
	// get number of slides	
	var slidesCount = slidesGetCount();
	// set slideCurrent
	if (slideCurrent >= slidesCount) {
		slideCurrent = 1;
	} else {
		slideCurrent++;
	}
	// hide all slides
	hideSlidesAll();
	// show current slide
	var slideCurrentName = "slide" + slideCurrent;
	var slideToShow = document.getElementById(slideCurrentName);
	slideToShow.style.display = "block";	
	// change sq img
	changeSq(slideCurrent);	
	// set timer
	if (slidesStatus == "play") {
		timeoutId = setTimeout("slideNext()",5000);
	}	
}


// function to go to previous slide
function slidePrevious() {
	// get number of slides	
	var slidesCount = slidesGetCount();
	// set slideCurrent
	if (slideCurrent <= 1) {
		slideCurrent = slidesCount;
	} else {
		slideCurrent--;
	}
	// hide all slides
	hideSlidesAll();
	// show current slide
	var slideCurrentName = "slide" + slideCurrent;
	var slideToShow = document.getElementById(slideCurrentName);
	slideToShow.style.display = "block";	
	// change sq img
	changeSq(slideCurrent);	
}


// function to show slide when square clicked
function showSlide(slide) {
	// hide all slides
	hideSlidesAll();
	// show new slide
	var slideName = "slide" + slide;
	var slideToShow = document.getElementById(slideName);
	slideToShow.style.display = "block";	
	// set slideCurrent
	slideCurrent = slide;
	// change sq img
	changeSq(slide);
}


// function to get slide count
function slidesGetCount() {
	// get number of slides	
	var slidesWrapper = document.getElementById("slidesWrapper_home");
	var slideDivs = slidesWrapper.getElementsByTagName("div");
	var slidesCount = 0;
	for (var i = 0; i < slideDivs.length; i++) {
		var className = slideDivs[i].getAttribute("name");
		if (className == "slides_home") {
			slidesCount++;
		}
	}
	return slidesCount;
}


// function to hide all slides
function hideSlidesAll() {
	var slidesWrapper = document.getElementById("slidesWrapper_home");
	//alert(slidesWrapper);
	var slideDivs = slidesWrapper.getElementsByTagName("div");
	for (var j = 0; j < slideDivs.length; j++) {
		var className = slideDivs[j].getAttribute("name");
		if (className == "slides_home") {
			slideDivs[j].style.display = "none";
		}
	}
}


// function to stop autoplay and timer
function slidesPause() {
	//alert("slidesPause called");
	slidesStatus = "pause";
	clearTimeout(timeoutId);
}


// function to chage square graphic from open to closed for current slide
function changeSq(sqId) {
	// set all squares to open	
	var slidesWrapper = document.getElementById("slidesWrapper_home");
	var sqImgs = slidesWrapper.getElementsByTagName("img");
	for (var i = 0; i < sqImgs.length; i++) {
		var className = sqImgs[i].getAttribute("name");
		if (className == "sq_home") {
			sqImgs[i].src = "Bolivia_files/storybullet-new.gif";
		}
	}
	// set current sq to closed
	var currentSqName = "sq" + sqId;
	var currentSq = document.getElementById(currentSqName);
	currentSq.src = "Bolivia_files/storybullet-new-on.gif";
}