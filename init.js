//This code adds all the event listeners we need
var fullscreen = false;
var openBtn = document.getElementById('open');
var fullscreenBtn = document.getElementById('fullscreen');
var patternWindow
var sharedObj = {} //this object will be shared with the pattern window when we make it
var canvas = document.getElementById("Canvas");


fullscreenBtn.addEventListener("click", function () {
	if (!patternWindow) {return}
	console.log("going fullscreen...")
	var docElm = patternWindow.document.getElementById("Canvas");
	if(!docElm){return}

	if(!fullscreen){
	if (docElm.requestFullscreen) { docElm.requestFullscreen(); }
	else if (docElm.msRequestFullscreen) { docElm.msRequestFullscreen(); }
	else if (docElm.mozRequestFullScreen) { docElm.mozRequestFullScreen(); }
	else if (docElm.webkitRequestFullScreen) { docElm.webkitRequestFullScreen(); }
	}else{
	if (document.exitFullscreen) { document.exitFullscreen(); }
	else if (document.msExitFullscreen) { document.msExitFullscreen(); }
	else if (document.mozCancelFullScreen) { document.mozCancelFullScreen(); }
	else if (document.webkitCancelFullScreen) { document.webkitCancelFullScreen(); }
	}
}, false)

function fullscreenChange(){
	console.log("fullscreen change!");
	console.log(fullscreen);
}
openBtn.addEventListener('click', function () {
	patternWindow = window.open("pattern.html", "?", "height=200,width=200");
	patternWindow.parameters = sharedObj; //share our object!
	//register callbacks in this new window... maybe??
	patternWindow.document.addEventListener("fullscreenchange", function () {
		fullscreen = patternWindow.document.fullscreenElement;
		fullscreenChange();
	}, false);

	patternWindow.document.addEventListener("msfullscreenchange", function () {
		fullscreen = patternWindow.document.msFullScreenElement;
		fullscreenChange();
	}, false);

	patternWindow.document.addEventListener("mozfullscreenchange", function () {
		fullscreen = patternWindow.document.mozFullScreen;
		fullscreenChange();
	}, false);

	patternWindow.document.addEventListener("webkitfullscreenchange", function () {
		fullscreen = patternWindow.document.webkitIsFullScreen;
		fullscreenChange();
	}, false);
}, false);
// now register even handlers to all the inputs
function registerParam(container, elem) {
    var name=inputElem.getAttribute('name');
    console.log("registered:")
    console.log(name)
    container[name] = Number(elem.value)
    
    elem.addEventListener("change", function () {
        container[name] = Number(elem.value)
        console.log(sharedObj)
		if(patternWindow){
			patternWindow.L.execute('gl.redraw();gl.finish()')
		}
    })
}
var elems = document.getElementsByTagName('*');
for( i in elems ){
    if (elems[i].className=='container'){ //this is a container!
        var id = elems[i].getAttribute('name');
        sharedObj[id] = sharedObj[id] || {}; //make the container object if it does not exist
        var obj = sharedObj[id];
        var params = elems[i].childNodes;
        for(j in params){
            if (params[j].className=="parameter") {
                var param = params[j]
                var children = params[j].childNodes;
                var inputElem;
                for(k in children){
                    if(children[k].tagName && children[k].tagName.toLowerCase()=="input"){inputElem = children[k];}
                }   
                if (inputElem) {
                    registerParam(obj, inputElem)
                }
            }
        }
    }
}
