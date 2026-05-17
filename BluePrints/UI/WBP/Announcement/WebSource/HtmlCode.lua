
local HtmlBody1 = 
[[<!DOCTYPE html>
<html lang="en">
    <head>
        <style> html { font-size : %svw; } </style>
        <base href="%s">
        <meta charset="UTF-8",>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" type="text/css" href="AnnounceWeb/Script/Announce.css?v=%s">
    </head>
    <script type="text/javascript" src="AnnounceWeb/Script/Announce.js?v=%s" charset="utf-8"></script>
    <body onselectstart="return false;" onmousedown="initdrag()" onmousemove="startdrag()" onmouseup="enddrag()" scroll=yes oncontextmenu="return false;">
        %s
    </body>
</html>]]

local DefaultContent = 
[[      <div class="content-container">  
            <div class="MainContent">
            <div style="height:2.2vw;"></div>
            <div class="TitleBar">%s</div>
                %s
            <div style="height:2vw;"></div>
            </div>
            <div class="right-space"></div>
        </div>
        <div class="before"></div>
        <div class="after"></div>]]

local ImageOnlyContent = 
[[      <div class="MainContent">
        <div style="height:2.2vw;"></div>
        <a href="%s">
            <img src="%s">
        </a>
        </div>]]

return {
    HtmlBody1 = HtmlBody1, 
    DefaultContent = DefaultContent, 
    ImageOnlyContent = ImageOnlyContent
}