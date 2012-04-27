/* Example tokeninput style #1: Token vertical list*/
ul.token-input-list {
    overflow: hidden; 
    height: auto !important; 
    height: 1%;
    width: 400px;
    border: 1px solid #999;
    cursor: text;
    font-size: 12px;
    font-family: Verdana;
    z-index: 999;
    margin: 0;
    padding: 0;
    background-color: #fff;
    list-style-type: none;
    clear: left;
}

ul.token-input-list li {
    list-style-type: none;
}

ul.token-input-list li input {
    border: 0;
    width: 350px;
    padding: 3px 8px;
    background-color: white;
    -webkit-appearance: caret;
}

li.token-input-token {
    overflow: hidden; 
    height: auto !important; 
    height: 1%;
    margin: 3px;
    padding: 3px 5px;
    background-color: #d0efa0;
    color: #000;
    font-weight: bold;
    cursor: default;
    display: block;
}

li.token-input-token p {
    float: left;
    padding: 0;
    margin: 0;
}

li.token-input-token span {
    float: right;
    color: #777;
    cursor: pointer;
}

li.token-input-selected-token {
    background-color: #08844e;
    color: #fff;
}

li.token-input-selected-token span {
    color: #bbb;
}

div.token-input-dropdown {
    position: absolute;
    width: 400px;
    background-color: #fff;
    overflow: hidden;
    border-left: 1px solid #ccc;
    border-right: 1px solid #ccc;
    border-bottom: 1px solid #ccc;
    cursor: default;
    font-size: 12px;
    font-family: Verdana;
    z-index: 1;
}

div.token-input-dropdown p {
    margin: 0;
    padding: 5px;
    font-weight: bold;
    color: #777;
}

div.token-input-dropdown ul {
    margin: 0;
    padding: 0;
}

div.token-input-dropdown ul li {
    background-color: #fff;
    padding: 3px;
    list-style-type: none;
}

div.token-input-dropdown ul li.token-input-dropdown-item {
    background-color: #fafafa;
}

div.token-input-dropdown ul li.token-input-dropdown-item2 {
    background-color: #fff;
}

div.token-input-dropdown ul li em {
    font-weight: bold;
    font-style: normal;
}

div.token-input-dropdown ul li.token-input-selected-dropdown-item {
    background-color: #d0efa0;
}

