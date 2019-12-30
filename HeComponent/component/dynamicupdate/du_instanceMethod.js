function MultiChannelDemoViewController_test_(obj, sel, args){
    var originalSel = "du_" + sel;
    
    var tempArray = new Array();
    tempArray.push(50);
    js_msgSend(obj,originalSel, tempArray);
    return 500;
}
