function checkContentKeyUp(obj,toObj,max){  
    // var content=document.getElementById("micropost_content");  
    var content=obj;
    var length=content.value.length;  
    var contentMsg = document.getElementById(toObj);  
    contentMsg.innerHTML = "您已输入<font color='red'>"  
                    + length  
                    + "</font>字符，还可输入<font color='red'>"  
                    + (max - length)  
                    + "</font>字符。";  
}  