local CssCode = [[
@charset "utf-8";

* {
    margin-top:0.015rem;
    margin-bottom:0.015rem;
    letter-spacing: 0.015rem;
    line-height:1.3;
}

body{
    transition: all 0.2s;
    overflow-x: hidden;
    overflow-y: hidden;
    opacity:0;
}

.content-container {
    display: flex;
    width: 100vw;
    height: 100%;
}

.right-space {
    width: 3vw;
    background: transparent;
}

.MainContent {
    width: 97vw;
    font-size:0.169216rem;
    font-family: "GameFont";
    color: #999999;
    scroll-behavior: smooth;
    user-select: none;
    cursor: default;
    position: relative;
}

.MainContent img {
    width: 94vw;
    height: 100%;
    display:block;
    margin-left:auto;
    margin-right:auto;
    object-fit: contain;
    border-top-left-radius: 2.4vw;
    border-bottom-right-radius: 2.4vw;
    justify-content: center;
    -webkit-user-drag: none;
    -moz-user-drag: none;
    -ms-user-drag: none;
    margin-top:0.05rem;
    margin-bottom:0.05rem;
}
.MainContent a {
    color:#8ab3f5;
}
.MainContent ul {
    padding-inline-start: 4vw;
    margin:1vw;
}
.MainContent ol {
    padding-inline-start: 4vw;
    margin:1vw;
}
.MainContent p {
    margin: 1vw;
}
.MainContent h3{
    margin: 1vw;
}

.before {
    content: "";
    position: fixed;
    top: 0;
    width: 100%;
    height: 3vw;
    background-image: linear-gradient(180deg, rgba(21,21,21,0.9) 0%, rgba(255, 255, 255, 0) 100%);
    pointer-events: none;
    user-select: none;
    margin-top:0rem;
    margin-bottom:0rem;
}

.after {
    content: "";
    position: fixed;
    bottom: 0;
    width: 100%;
    height: 3vw;
    background-image: linear-gradient(180deg, rgba(255, 255, 255, 0) 0%, rgba(21,21,21,0.9) 100%);
    pointer-events: none;
    user-select: none;
    margin-top:0rem;
    margin-bottom:0rem;
}


::-webkit-scrollbar-thumb {
    margin-top:3vw;
    /*滚动条里面小方块*/
    border-top-left-radius: 6px;
    border-bottom-right-radius: 6px;
    box-shadow : inset 0 0 1px rgba(0, 0, 0, 0.2);
    background : #7C736E;
    margin-bottom:1.6vw;
}
::-webkit-scrollbar-track {
    margin-top:3vw;
    /*滚动条里面轨道*/
    box-shadow : inset 0 0 1px rgba(0, 0, 0, 0.2);
    border-top-left-radius: 6px;
    border-bottom-right-radius: 6px;
    background : #292929;
    margin-bottom:1.6vw;
}

.TitleBar{
    object-fit: contain;
    border-top-width: 1vw ;
    border-bottom-width: 1vw ;
    border-right-width: 3vw ;
    border-left-width: 3vw ;
    border-style: solid;
    border-image-source: url("../Image/TitleBg.png");
    border-image-slice: 15 15 15 15 fill;
    border-image-width: 2.5vw;
    font-size: 0.27074992rem;
    color: #ffffff;
    margin-bottom:0.05rem;
}
]]

return CssCode