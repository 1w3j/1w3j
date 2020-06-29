// an example to create a new mapping `ctrl-y`
mapkey('<Ctrl-y>', 'Show me the money', function() {
    Front.showPopup('a well-known phrase uttered by characters in the 1996 film Jerry Maguire (Escape to close).');
});

addSearchAlias("git", "github", "https://github.com/search?q=");
addSearchAlias("mam", "myanonamouse", "https://www.myanonamouse.net/tor/browse.php?action=search&tor%5BsrchIn%5D=1&tor%5Btext%5D=");

// an example to replace `T` with `gt`, click `Default mappings` to see how `T` works.
map('gt', 'T');

// an example to remove mapkey `Ctrl-i`
unmap('<Ctrl-i>');

// 1w3j theme link hints
Hints.style('font-size: 11pt!important; border: solid 1px #D1292D!important; color:#e99499!important; background: initial; background-color: #0C0909!important;');
// Text hints
Hints.style("font-size: 11pt!important; border: solid 1px #FFA2A7!important; color:#D9898E!important; padding: 1px;background: #0C0909!important", "text");
// Search marks and cursor
Visual.style('marks', 'background-color: #300A0A;');
Visual.style('cursor', 'background-color: #FFA2A7;');

// set theme
settings.theme = `
.sk_theme {
    background: #0C0909;
    color: #e99499;
}
.sk_theme input {
    color: #e99499;
    font-size: 13pt;
}
.sk_theme .url {
    color: #222;
}
.sk_theme .annotation {
    color: #222;
}
.sk_theme kbd {
    background: #0C0909;
    color: #FFA2A7;
    font-size: 12pt;
}
.sk_theme .frame {
    background: rgba(174, 25, 20, 0.62);
}
.sk_theme .omnibar_highlight {
    color: #b90c0c;
}
.sk_theme .omnibar_folder {
    color: #4b3acc;
}
.sk_theme .omnibar_timestamp {
    color: #cc4b9c;
}
.sk_theme .omnibar_visitcount {
    color: #1e46e9;
}
.sk_theme .prompt, .sk_theme .resultPage {
    color: #aaa;
}
.sk_theme .feature_name {
    color: #e09b7e;
}
.sk_theme .separator {
    color: #b5b507;
}

body {
    margin: 0;
    font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
    font-size: 13px;
}
#sk_omnibar {
    overflow: hidden;
    position: fixed;
    width: 80%;
    max-height: 80%;
    left: 10%;
    text-align: left;
    box-shadow: 0px 2px 10px rgba(0, 0, 0, 0.8);
    z-index: 2147483000;
}
.sk_omnibar_middle {
    top: 10%;
    border-radius: 4px;
}
.sk_omnibar_bottom {
    bottom: 0;
    border-radius: 4px 4px 0px 0px;
}
#sk_omnibar span.omnibar_highlight {
    text-shadow: 0 0 0.01em;
}
#sk_omnibarSearchArea .prompt, #sk_omnibarSearchArea .resultPage {
    display: inline-block;
    font-size: 20px;
    width: auto;
}
#sk_omnibarSearchArea>input {
    display: inline-block;
    flex: 1;
    font-size: 20px;
    margin-bottom: 0;
    padding: 0px 0px 0px 0.5rem;
    background: transparent;
    border-style: none;
    outline: none;
}
#sk_omnibarSearchArea {
    display: flex;
}
.sk_omnibar_middle #sk_omnibarSearchArea {
    margin: 0.5rem 1rem;
    border-bottom: 1px solid #999;
}
.sk_omnibar_bottom #sk_omnibarSearchArea {
    margin: 0.2rem 1rem;
    border-top: 1px solid #999;
}
.sk_omnibar_middle #sk_omnibarSearchResult>ul {
    margin-top: 0;
}
.sk_omnibar_bottom #sk_omnibarSearchResult>ul {
    margin-bottom: 0;
}
#sk_omnibarSearchResult {
    max-height: 600px;
    overflow: hidden;
    margin: 0rem 0.6rem;
}
#sk_omnibarSearchResult:empty {
    display: none;
}
#sk_omnibarSearchResult>ul {
    padding: 0;
}
#sk_omnibarSearchResult>ul>li {
    padding: 0.2rem 0rem;
    display: block;
    max-height: 600px;
    overflow-x: hidden;
    overflow-y: auto;
}
.sk_theme #sk_omnibarSearchResult>ul>li:nth-child(odd) {
    background: #1A0403;
}
.sk_theme #sk_omnibarSearchResult>ul>li.focused {
    background: #8F1510;
}
.sk_theme div.table {
    display: table;
}
.sk_theme div.table>* {
    vertical-align: middle;
    display: table-cell;
}
#sk_omnibarSearchResult li div.title {
    text-align: left;
}
#sk_omnibarSearchResult li div.url {
    font-weight: bold;
    white-space: nowrap;
}
#sk_omnibarSearchResult li.focused div.url {
    white-space: normal;
}
#sk_omnibarSearchResult li span.annotation {
    float: right;
}
#sk_status {
    position: fixed;
    bottom: 0;
    right: 20%;
    z-index: 2147483000;
    padding: 4px 8px 0 8px;
    border-radius: 4px 4px 0px 0px;
    border: 1px solid #80120F;
    font-size: 13pt;
}
#sk_status>span {
    line-height: 16px;
    color: #FFA2A7;
    border-right-color: #a3676b!important;
}
.expandRichHints span.annotation {
    padding-left: 4px;
    color: #e99499;
}
.expandRichHints .kbd-span {
    min-width: 30px;
    text-align: right;
    display: inline-block;
}
.expandRichHints kbd>.candidates {
    color: #E8332E;
    font-weight: bold;
}
.expandRichHints kbd {
    padding: 1px 2px;
    color: #FFA2A7;
}
#sk_find {
    border-style: none;
    outline: none;
}
#sk_keystroke {
    padding: 6px;
    position: fixed;
    float: right;
    bottom: 0px;
    z-index: 2147483000;
    right: 0px;
    background: #0C0909;
    color: #e99499;
    border: 2px solid #B22828;
}
#sk_usage, #sk_popup, #sk_editor {
    overflow: auto;
    position: fixed;
    width: 80%;
    max-height: 80%;
    top: 10%;
    left: 10%;
    text-align: left;
    box-shadow: 0px 2px 10px rgba(0, 0, 0, 0.8);
    z-index: 2147483298;
    padding: 1rem;
}
#sk_popup img {
    width: 100%;
}
#sk_usage>div {
    display: inline-block;
    vertical-align: top;
}
#sk_usage .kbd-span {
    width: 80px;
    text-align: right;
    display: inline-block;
}
#sk_usage .feature_name {
    text-align: center;
    padding-bottom: 4px;
}
#sk_usage .feature_name>span {
    border-bottom: 2px solid #8C1410;
}
#sk_usage span.annotation {
    padding-left: 32px;
    line-height: 22px;
}
#sk_usage * {
    font-size: 11pt;
    color: #e99499;
}
kbd {
    white-space: nowrap;
    display: inline-block;
    padding: 3px 5px;
    font: 11px Consolas, "Liberation Mono", Menlo, Courier, monospace;
    line-height: 10px;
    vertical-align: middle;
    border: solid 1px #8C1410;
    border-bottom-color: #8C1410;
    border-radius: 3px;
    box-shadow: inset 0 -1px 0 #AE1914;
}
#sk_banner {
    padding: 0.5rem;
    position: fixed;
    left: 10%;
    top: -3rem;
    z-index: 2147483000;
    width: 80%;
    border-radius: 0px 0px 4px 4px;
    border: 1px solid #00ff3d;
    border-top-style: none;
    text-align: center;
    background: rgb(255, 233, 182);
    white-space: nowrap;
    text-overflow: ellipsis;
    overflow: hidden;
}
#sk_tabs {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: transparent;
    overflow: auto;
    z-index: 2147483000;
}
div.sk_tab {
    display: inline-block;
    border-radius: 3px;
    padding: 10px 20px;
    margin: 5px;
    background: #5E1513;
    box-shadow: 0px 3px 7px 0px rgba(0, 0, 0, 0.3);
}
div.sk_tab_wrap {
    display: inline-block;
}
div.sk_tab_icon {
    display: inline-block;
    vertical-align: middle;
}
div.sk_tab_icon>img {
    width: 18px;
}
div.sk_tab_title {
    width: 150px;
    display: inline-block;
    vertical-align: middle;
    font-size: 10pt;
    white-space: nowrap;
    text-overflow: ellipsis;
    overflow: hidden;
    padding-left: 5px;
    color: #FFA2A7;
}
div.sk_tab_url {
    font-size: 10pt;
    white-space: nowrap;
    text-overflow: ellipsis;
    overflow: hidden;
    color: #a3676b;
}
div.sk_tab_hint {
    display: inline-block;
    float:right;
    font-size: 10pt;
    font-weight: bold;
    padding: 0px 2px 0px 2px;
    background: #0C0909;
    color: #FFA2A7;
    border: solid 1px #DC282E;
    border-radius: 3px;
    box-shadow: 0px 3px 7px 0px rgba(0, 0, 0, 0.3);
}
#sk_bubble {
    position: absolute;
    padding: 9px;
    border: 1px solid #999;
    border-radius: 4px;
    box-shadow: 0 0 20px rgba(0,0,0,0.5);
    color: #222;
    background-color: #ffd;
    z-index: 2147483000;
    font-size: 12pt;
}
#sk_bubble .sk_bubble_content {
    overflow-y: scroll;
    background-size: 3px 100%;
    background-position: 100%;
    background-repeat: no-repeat;
}
.sk_scroller_indicator_top {
    background-image: linear-gradient(rgb(0, 0, 0), transparent);
}
.sk_scroller_indicator_middle {
    background-image: linear-gradient(transparent, rgb(0, 0, 0), transparent);
}
.sk_scroller_indicator_bottom {
    background-image: linear-gradient(transparent, rgb(0, 0, 0));
}
#sk_bubble * {
    color: #000 !important;
}
div.sk_arrow>div:nth-of-type(1) {
    left: 0;
    position: absolute;
    width: 0;
    border-left: 12px solid transparent;
    border-right: 12px solid transparent;
    background: transparent;
}
div.sk_arrow[dir=down]>div:nth-of-type(1) {
    border-top: 12px solid #999;
}
div.sk_arrow[dir=up]>div:nth-of-type(1) {
    border-bottom: 12px solid #999;
}
div.sk_arrow>div:nth-of-type(2) {
    left: 2px;
    position: absolute;
    width: 0;
    border-left: 10px solid transparent;
    border-right: 10px solid transparent;
    background: transparent;
}
div.sk_arrow[dir=down]>div:nth-of-type(2) {
    border-top: 10px solid #ffd;
}
div.sk_arrow[dir=up]>div:nth-of-type(2) {
    top: 2px;
    border-bottom: 10px solid #ffd;
}
.ace_editor.ace_autocomplete {
    z-index: 2147483300 !important;
    width: 80% !important;
}`;
