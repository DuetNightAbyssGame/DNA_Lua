local JsCode = [[
// -*- coding: utf-8 -*-

function setScrollbarWidth() {
     // 使用ID避免重复创建样式
    let styleSheet = document.getElementById('scrollbar-style');
    if (!styleSheet) {
        styleSheet = document.createElement('style');
        styleSheet.id = 'scrollbar-style';
        document.head.appendChild(styleSheet);
    }
    let width = document.documentElement.clientWidth / 160
    styleSheet.type = 'text/css';
    styleSheet.innerText = `
            :hover::-webkit-scrollbar {
                width: ${width}px;
                height: ${width}px;
                scroll-behavior: smooth;
            }
            :not(:hover)::-webkit-scrollbar{
                width:0;
                height:0;
            }
            ::-webkit-scrollbar:hover {
                width: ${width}px;
                height: ${width}px;
                scroll-behavior: smooth;
            }
            :not(:hover)::-webkit-scrollbar:not(:hover){
                width:0;
                height:0;
            }`;
}

function setAllHyperlink() {
    let links = document.querySelectorAll('a');
    for (let i = 0; i < links.length; i++) {
        links[i].setAttribute('target', '_blank');
        let href = links[i].getAttribute("href")
        if (href) {
            links[i].addEventListener("click",function(event){
                if(window.ue) {
                    window.ue.obj.onbeforepopup(href,"")
                }
            })
        }
    }
}

function makeFontface(){
    const searchParams = new URLSearchParams(window.location.search)
    let fontUrl = searchParams.get("fontUrl")
    console.log(fontUrl)
    if(fontUrl == null) {return;}
    let gameFont = new FontFace("GameFont", `url(${fontUrl})`)
    gameFont.display = "block"
    gameFont.load().then(function(loadFace){
        document.fonts.add(loadFace);
    });
}

let disableScroll = "false"

window.onload = () => {
    window.onresize = ()=>{
        setScrollbarWidth()
    }
    document.body.style.opacity = 1;
    const searchParams = new URLSearchParams(window.location.search)
    disableScroll = searchParams.get("disableScroll")
    if(disableScroll == "true"){
        document.body.style.overflowY = "hidden";
    } else {
        document.body.style.overflowY = "auto";
    }
    setScrollbarWidth()
    setAllHyperlink()
}

let scrollcount = 0;
let dragy;
let scrollarrowtop;
function initdrag() {
    if(disableScroll == "true"){
        return;
    }
    scrollcount = 1;
    dragy = event.clientY;
}

function startdrag() {
    if(disableScroll == "true"){
        return;
    }
    if (scrollcount == 1) {
        window.scrollBy(0, dragy - event.clientY);
        document.body.style.cursor = 'hand';
        dragy = event.clientY;
    }
}

function enddrag() {
    if(disableScroll == "true"){
        return;
    }
    document.body.style.cursor = '';
    scrollcount = 0;
}
document.addEventListener("mouseout",function(event){
    if(event.relatedTarget == null){
        enddrag();
    }
});

makeFontface()
]]

return JsCode